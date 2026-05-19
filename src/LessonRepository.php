<?php
class LessonRepository extends AbstractRepository {
    public function __construct(PDO $pdo) {
        parent::__construct($pdo, 'lessons', 'lesson_id');
    }

    public function getLessonsByDate(string $date): array {
        $stmt = $this->pdo->prepare("SELECT * FROM lessons WHERE DATE(lesson_datetime) = ? ORDER BY lesson_datetime");
        $stmt->execute([$date]);
        return $stmt->fetchAll();
    }

    public function getTeacherLoad(int $teacherId, string $startDate, string $endDate): array {
        $sql = "SELECT i.instrument_name, COUNT(l.lesson_id) as total_lessons, SUM(l.duration_minutes) as total_minutes
                FROM lessons l JOIN instruments i ON l.instrument_id = i.instrument_id
                WHERE l.teacher_id = ? AND l.lesson_datetime BETWEEN ? AND ?
                GROUP BY i.instrument_id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([$teacherId, $startDate, $endDate]);
        return $stmt->fetchAll();
    }

    public function createLessonWithValidation(int $studentId, int $teacherId, int $instrumentId, string $datetime, int $duration): int {
        $this->pdo->beginTransaction();
        try {
            // Проверка бизнес-правила: 1 урок в день по инструменту на ученика
            $check1 = $this->pdo->prepare("SELECT COUNT(*) FROM lessons WHERE student_id=? AND instrument_id=? AND DATE(lesson_datetime)=DATE(?)");
            $check1->execute([$studentId, $instrumentId, $datetime]);
            if ($check1->fetchColumn() > 0) throw new RepositoryException("Ученик уже записан на этот инструмент в этот день.");

            // Проверка занятости слота преподавателя
            $check2 = $this->pdo->prepare("SELECT COUNT(*) FROM lessons WHERE teacher_id=? AND lesson_datetime=?");
            $check2->execute([$teacherId, $datetime]);
            if ($check2->fetchColumn() > 0) throw new RepositoryException("Слот преподавателя уже занят.");

            $this->insert([
                'student_id' => $studentId,
                'teacher_id' => $teacherId,
                'instrument_id' => $instrumentId,
                'lesson_datetime' => $datetime,
                'duration_minutes' => $duration,
                'status' => 'запланировано'
            ]);

            $this->pdo->commit();
            return (int)$this->pdo->lastInsertId();
        } catch (PDOException $e) {
            $this->pdo->rollBack();
            throw new RepositoryException("Ошибка создания урока: " . $e->getMessage(), 0, $e);
        }
    }
}
