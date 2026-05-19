-- ============================================
-- Вариант 4: Частная музыкальная школа
-- Файл: sql/schema.sql
-- ============================================

SET NAMES utf8mb4;

CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE instruments (
    instrument_id INT AUTO_INCREMENT PRIMARY KEY,
    instrument_name VARCHAR(100) NOT NULL,
    description TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE teacher_instruments (
    teacher_id INT NOT NULL,
    instrument_id INT NOT NULL,
    PRIMARY KEY (teacher_id, instrument_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    enrollment_date DATE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE lessons (
    lesson_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    teacher_id INT NOT NULL,
    instrument_id INT NOT NULL,
    lesson_datetime DATETIME NOT NULL,
    duration_minutes INT NOT NULL DEFAULT 60,
    status VARCHAR(20) NOT NULL DEFAULT 'запланировано',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE homework (
    homework_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    teacher_id INT NOT NULL,
    instrument_id INT NOT NULL,
    issue_date DATE NOT NULL,
    deadline DATE NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'выдано'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ТЕСТОВЫЕ ДАННЫЕ
INSERT INTO teachers (last_name, first_name, patronymic, phone, email, hire_date) VALUES
('Соколов', 'Андрей', 'Петрович', '+79161112233', 'sokolov@music.ru', '2024-01-15'),
('Морозова', 'Елена', 'Игоревна', '+79162223344', 'morozova@music.ru', '2023-09-01'),
('Волков', 'Дмитрий', 'Сергеевич', '+79163334455', 'volkov@music.ru', '2025-03-10');

INSERT INTO instruments (instrument_name, description) VALUES
('Фортепиано', 'Акустическое и цифровое'),
('Скрипка', 'Классическая, 4/4'),
('Гитара', 'Акустическая, электро'),
('Флейта', 'Поперечная, профессиональная');

INSERT INTO teacher_instruments (teacher_id, instrument_id) VALUES
(1, 1), (1, 2),
(2, 1), (2, 4),
(3, 3);

INSERT INTO students (last_name, first_name, patronymic, phone, email, birth_date, enrollment_date) VALUES
('Иванов', 'Максим', 'Алексеевич', '+79261112233', 'ivanov.m@example.com', '2010-03-15', '2024-09-01'),
('Петрова', 'Анна', 'Дмитриевна', '+79262223344', 'petrova.a@example.com', '2008-07-22', '2023-09-01'),
('Сидоров', 'Кирилл', 'Владимирович', '+79263334455', 'sidorov.k@example.com', '2012-01-10', '2025-01-15');

INSERT INTO lessons (student_id, teacher_id, instrument_id, lesson_datetime, duration_minutes) VALUES
(1, 1, 1, '2026-05-20 10:00:00', 60),
(2, 1, 1, '2026-05-20 11:30:00', 60),
(1, 1, 1, '2026-05-20 14:00:00', 60),
(3, 1, 1, '2026-05-20 15:30:00', 60),
(2, 1, 1, '2026-05-21 09:00:00', 60),
(1, 1, 1, '2026-05-21 10:30:00', 60),
(3, 1, 1, '2026-05-21 13:00:00', 60),
(2, 1, 1, '2026-05-21 16:00:00', 60),
(1, 2, 4, '2026-05-22 11:00:00', 45),
(3, 3, 3, '2026-05-25 12:00:00', 60);

INSERT INTO homework (student_id, teacher_id, instrument_id, issue_date, deadline, description) VALUES
(1, 1, 1, '2026-05-15', '2026-05-22', 'Гамма До мажор, 2 октавы'),
(2, 1, 1, '2026-05-16', '2026-05-23', 'Этюд №5 Черни'),
(1, 2, 4, '2026-05-18', '2026-05-25', 'Упражнения на звукоизвлечение');
