<?php
abstract class AbstractRepository {
    protected PDO $pdo;
    protected string $table;
    protected string $primaryKey;

    public function __construct(PDO $pdo, string $table, string $primaryKey = 'id') {
        $this->pdo = $pdo;
        $this->table = $table;
        $this->primaryKey = $primaryKey;
    }

    public function findAll(array $where = [], string $orderBy = null, int $limit = null): array {
        $sql = "SELECT * FROM {$this->table}";
        $params = [];
        $conditions = [];

        foreach ($where as $col => $val) {
            $conditions[] = "$col = ?";
            $params[] = $val;
        }
        if ($conditions) {
            $sql .= " WHERE " . implode(' AND ', $conditions);
        }

        if ($orderBy) {
            $parts = explode(' ', $orderBy);
            $col = $parts[0];
            $dir = strtoupper($parts[1] ?? 'ASC');
            $allowedCols = ['id', 'name', 'date', 'created_at', 'deadline', 'lesson_datetime', 'last_name', 'first_name'];
            if (in_array($col, $allowedCols, true) && in_array($dir, ['ASC', 'DESC'], true)) {
                $sql .= " ORDER BY $col $dir";
            }
        }

        if ($limit !== null) {
            $sql .= " LIMIT ?";
            $params[] = (int)$limit;
        }

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    public function findById(int $id): ?array {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->table} WHERE {$this->primaryKey} = ?");
        $stmt->execute([$id]);
        $res = $stmt->fetch();
        return $res ?: null;
    }

    public function insert(array $data): int {
        $cols = array_keys($data);
        $placeholders = array_fill(0, count($cols), '?');
        $sql = "INSERT INTO {$this->table} (" . implode(', ', $cols) . ") VALUES (" . implode(', ', $placeholders) . ")";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(array_values($data));
        return (int)$this->pdo->lastInsertId();
    }

    public function update(int $id, array $data): bool {
        $cols = array_keys($data);
        $set = implode(', ', array_map(fn($c) => "$c = ?", $cols));
        $sql = "UPDATE {$this->table} SET $set WHERE {$this->primaryKey} = ?";
        $params = array_values($data);
        $params[] = $id;
        return $this->pdo->prepare($sql)->execute($params);
    }

    public function delete(int $id): bool {
        return $this->pdo->prepare("DELETE FROM {$this->table} WHERE {$this->primaryKey} = ?")->execute([$id]);
    }
}
