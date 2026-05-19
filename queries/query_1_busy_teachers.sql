-- Запрос 1: Преподаватели, у которых нет свободных окон в ближайшие 2 дня
SELECT
    t.teacher_id,
    CONCAT(t.last_name, ' ', t.first_name, ' ', t.patronymic) AS full_name,
    COUNT(l.lesson_id) AS booked_lessons
FROM teachers t
LEFT JOIN lessons l ON t.teacher_id = l.teacher_id
    AND l.lesson_datetime >= '2026-05-20 00:00:00'
    AND l.lesson_datetime < '2026-05-22 00:00:00'
    AND l.status = 'запланировано'
GROUP BY t.teacher_id
HAVING booked_lessons > 0
ORDER BY booked_lessons DESC;
