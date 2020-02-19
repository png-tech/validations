SELECT * FROM (
                  SELECT mh2.message_id           AS id,
                         mh2.text,
                         mh2.version,
                         mh2.commentary,
                         m.message_id is null as deactivated
                  FROM (SELECT mh.message_id   AS id,
                               MAX(mh.version) AS maxVersion
                        FROM message_h mh
                        GROUP BY mh.message_id
                        ORDER BY mh.message_id) AS maxVersions
                           JOIN message_h mh2 on mh2.message_id = maxVersions.id AND mh2.version = maxVersions.maxVersion
                           LEFT JOIN message m on m.message_id = maxVersions.id
) wrapper