<?php
class TeacherRepository extends AbstractRepository {
    public function __construct(PDO $pdo) { parent::__construct($pdo, 'teachers', 'teacher_id'); }
}
