SELECT
  operation_version_id AS id,
  date,
  username,
  commentary
FROM operation_h
WHERE operation_id = :id and 1 = 0
ORDER BY date