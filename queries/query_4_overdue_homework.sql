-- Запрос 4: Ученики с просроченными домашними заданиями
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    i.instrument_name,
    h.deadline,
    DATEDIFF(CURDATE(), h.deadline) AS days_overdue
FROM students s
JOIN homework h ON s.student_id = h.student_id
JOIN instruments i ON h.instrument_id = i.instrument_id
WHERE h.deadline < CURDATE()
    AND h.status != 'сдано'
ORDER BY days_overdue DESC;
