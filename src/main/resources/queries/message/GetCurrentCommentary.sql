SELECT mh2.commentary
FROM (SELECT mh.message_id AS id,
             MAX(mh.version)  AS version
      FROM message_h mh
      GROUP BY mh.message_id) AS maxVersions
         JOIN message_h mh2 on mh2.message_id = maxVersions.id AND mh2.version = maxVersions.version
         LEFT JOIN message m on m.message_id = maxVersions.id
WHERE mh2.message_id = :messageId