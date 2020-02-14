SELECT *
FROM (
         SELECT oh2.operation_id       AS id,
                oh2.name,
                oh2.description,
                oh2.version,
                oh2.commentary,
                o.operation_id is null as deactivated
         FROM (SELECT oh.operation_id AS id,
                      MAX(oh.version) AS maxVersion
               FROM operation_h oh
               GROUP BY oh.operation_id
               ORDER BY oh.operation_id) AS maxVersions
                  JOIN operation_h oh2 on oh2.operation_id = maxVersions.id AND oh2.version = maxVersions.maxVersion
                  LEFT JOIN operation o on o.operation_id = maxVersions.id
         ORDER BY oh2.operation_id
     ) wrapper