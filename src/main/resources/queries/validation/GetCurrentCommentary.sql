SELECT vh2.commentary
FROM (SELECT vh.validation_id AS id,
             MAX(vh.version)  AS version
      FROM validation_h vh
      GROUP BY vh.validation_id) AS maxVersions
         JOIN validation_h vh2 on vh2.validation_id = maxVersions.id AND vh2.version = maxVersions.version
         LEFT JOIN validation v on v.validation_id = maxVersions.id
WHERE vh2.validation_id = :validationId