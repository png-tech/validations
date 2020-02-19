SELECT * FROM (
                  SELECT eh2.entity_id        AS id,
                         eh2.name,
                         eh2.description,
                         eh2.version,
                         eh2.commentary,
                         e.entity_id is null as deactivated
                  FROM (SELECT eh.entity_id    AS id,
                               MAX(eh.version) AS maxVersion
                        FROM entity_h eh
                        GROUP BY eh.entity_id
                        ORDER BY eh.entity_id) AS maxVersions
                           JOIN entity_h eh2 on eh2.entity_id = maxVersions.id AND eh2.version = maxVersions.maxVersion
                           LEFT JOIN entity e on e.entity_id = maxVersions.id
                  ORDER BY eh2.entity_id
) wrapper