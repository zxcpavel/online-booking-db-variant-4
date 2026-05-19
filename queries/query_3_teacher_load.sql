-- Запрос 3: Количество уроков у каждого преподавателя
SELECT
    CONCAT(t.last_name, ' ', LEFT(t.first_name, 1), '.') AS teacher,
    i.instrument_name,
    COUNT(l.lesson_id) AS total_lessons,
    SUM(l.duration_minutes) AS total_minutes
FROM teachers t
JOIN lessons l ON t.teacher_id = l.teacher_id
JOIN instruments i ON l.instrument_id = i.instrument_id
GROUP BY t.teacher_id, i.instrument_id
ORDER BY total_minutes DESC;
