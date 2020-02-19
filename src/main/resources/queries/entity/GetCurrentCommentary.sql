SELECT eh2.commentary
FROM (SELECT eh.entity_id AS id,
             MAX(eh.version)  AS version
      FROM entity_h eh
      GROUP BY eh.entity_id) AS maxVersions
         JOIN entity_h eh2 on eh2.entity_id = maxVersions.id AND eh2.version = maxVersions.version
         LEFT JOIN entity e on e.entity_id = maxVersions.id
WHERE eh2.entity_id = :entityId