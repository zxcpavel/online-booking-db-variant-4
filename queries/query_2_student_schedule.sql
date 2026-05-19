-- Запрос 2: Расписание конкретного ученика
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    CONCAT(t.last_name, ' ', t.first_name) AS teacher,
    i.instrument_name,
    l.lesson_datetime,
    l.duration_minutes,
    l.status
FROM lessons l
JOIN students s ON l.student_id = s.student_id
JOIN teachers t ON l.teacher_id = t.teacher_id
JOIN instruments i ON l.instrument_id = i.instrument_id
WHERE s.student_id = 1
ORDER BY l.lesson_datetime;
