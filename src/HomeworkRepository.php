<?php
class HomeworkRepository extends AbstractRepository {
    public function __construct(PDO $pdo) { parent::__construct($pdo, 'homework', 'homework_id'); }
}
