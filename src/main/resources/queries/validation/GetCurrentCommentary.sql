SELECT vh2.commentary
FROM (SELECT vh.validation_id AS id,
             MAX(vh.version)  AS version
      FROM validation_h vh
      GROUP BY vh.validation_id) AS maxVersions
         JOIN validation_h vh2 on vh2.validation_id = maxVersions.id AND vh2.version = maxVersions.version
      AND NOT EXISTS(SELECT * FROM validation v WHERE v.validation_id = vh2.validation_id)
WHERE vh2.validation_id = :validationId
UNION
SELECT commentary FROM validation
WHERE validation_id = :validationId