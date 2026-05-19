<?php
class StudentRepository extends AbstractRepository {
    public function __construct(PDO $pdo) { parent::__construct($pdo, 'students', 'student_id'); }
}
