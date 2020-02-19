SELECT vh2.validation_id AS v_id,

       e.entity_id       AS e_id,
       e.name            AS e_name,
       e.description     AS e_description,
       e.version         AS e_version,
       e.commentary      AS e_commentary,

       o.operation_id    AS o_id,
       o.name            AS o_name,
       o.description     AS o_description,
       o.version         AS o_version,
       o.commentary      AS o_commentary
FROM (SELECT vh.validation_id AS id,
             MAX(vh.version)  AS maxVersion
      FROM validation_h vh
      GROUP BY vh.validation_id
      ORDER BY vh.validation_id) AS maxVersions
         JOIN validation_h vh2 ON vh2.validation_id = maxVersions.id AND vh2.version = maxVersions.maxVersion
         JOIN validation_entity_operation_h veoh on vh2.validation_version_id = veoh.validation_version_id
         JOIN entity_h eh2 on veoh.entity_version_id = eh2.entity_version_id
         JOIN entity e on eh2.entity_id = e.entity_id
         JOIN operation_h oh2 on veoh.operation_version_id = oh2.operation_version_id
         JOIN operation o on oh2.operation_id = o.operation_id
WHERE vh2.validation_id IN (:ids)
ORDER BY vh2.validation_id