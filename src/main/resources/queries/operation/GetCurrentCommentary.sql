SELECT oh2.commentary
FROM (SELECT oh.operation_id AS id,
             MAX(oh.version)  AS version
      FROM operation_h oh
      GROUP BY oh.operation_id) AS maxVersions
         JOIN operation_h oh2 on oh2.operation_id = maxVersions.id AND oh2.version = maxVersions.version
         LEFT JOIN operation o on o.operation_id = maxVersions.id
WHERE oh2.operation_id = :operationId