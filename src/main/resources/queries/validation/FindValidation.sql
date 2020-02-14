SELECT *
FROM (
         SELECT vh2.validation_id                  AS id,
                mh.message_id                      AS messageId,
                mh.text                            AS messageText,
                vh2.description                    AS description,
                vh2.version                        AS version,
                vh2.commentary                     AS commentary,
                s.severity_id                      AS severityId,
                s.name                             AS severityName,
                string_agg(DISTINCT eh.name, ', ') AS entityNames,
                string_agg(DISTINCT oh.name, ', ') AS operationNames,
                string_agg(DISTINCT th.name, ', ') AS tagNames,
                v.validation_id is null            AS deactivated
         FROM (SELECT vh.validation_id AS id,
                      MAX(vh.version)  AS version
               FROM validation_h vh
               GROUP BY vh.validation_id) AS maxVersions
                  JOIN validation_h vh2 on vh2.validation_id = maxVersions.id AND vh2.version = maxVersions.version
                  LEFT JOIN validation v on vh2.validation_id = v.validation_id
                  JOIN message_h mh on vh2.message_version_id = mh.message_version_id
                  JOIN validation_entity_operation_h veoh on vh2.validation_version_id = veoh.validation_version_id
                  JOIN operation_h oh on veoh.operation_version_id = oh.operation_version_id
                  JOIN entity_h eh on veoh.entity_version_id = eh.entity_version_id
                  JOIN severity s on vh2.severity_id = s.severity_id
                  LEFT JOIN validation_tag_h vth on vh2.validation_version_id = vth.validation_version_id
                  LEFT JOIN tag_h th on vth.tag_version_id = th.tag_version_id
         GROUP BY vh2.validation_version_id, mh.message_version_id, s.severity_id, v.validation_id, vh2.validation_id
         ORDER BY vh2.validation_id
     ) wrapper