SELECT *
FROM (
         SELECT th2.tag_id       AS id,
                th2.name,
                th2.version,
                th2.description,
                th2.commentary,
                t.tag_id is null as deactivated
         FROM (SELECT th.tag_id       AS id,
                      MAX(th.version) AS maxVersion
               FROM tag_h th
               GROUP BY th.tag_id
               ORDER BY th.tag_id) AS maxVersions
                  JOIN tag_h th2 on th2.tag_id = maxVersions.id AND th2.version = maxVersions.maxVersion
                  LEFT JOIN tag t on t.tag_id = maxVersions.id
     ) wrapper