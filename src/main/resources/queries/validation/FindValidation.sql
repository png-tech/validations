SELECT * FROM (
    (SELECT vh2.validation_id                  AS id,
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
                      true                               AS deactivated
               FROM (SELECT vh.validation_id AS id,
                            MAX(vh.version)  AS version
                     FROM validation_h vh
                     GROUP BY vh.validation_id) AS maxVersions
                        JOIN validation_h vh2 on vh2.validation_id = maxVersions.id AND vh2.version = maxVersions.version
                   AND NOT EXISTS(SELECT * FROM validation v WHERE v.validation_id = vh2.validation_id)
                        JOIN message_h mh on vh2.message_version_id = mh.message_version_id
                        JOIN validation_entity_operation_h veoh on vh2.validation_version_id = veoh.validation_version_id
                        JOIN operation_h oh on veoh.operation_version_id = oh.operation_version_id
                        JOIN entity_h eh on veoh.entity_version_id = eh.entity_version_id
                        JOIN severity s on vh2.severity_id = s.severity_id
                        LEFT JOIN validation_tag_h vth on vh2.validation_version_id = vth.validation_version_id
                        LEFT JOIN tag_h th on vth.tag_version_id = th.tag_version_id
               GROUP BY vh2.validation_version_id, mh.message_version_id, s.severity_id
               ORDER BY vh2.validation_version_id)
    UNION
    (SELECT v.validation_id                    AS id,
        m.message_id                       AS messageId,
        m.text                             AS messageText,
        v.description                      AS description,
        v.version                          AS version,
        v.commentary                       AS commentary,
        s.severity_id                      AS severityId,
        s.name                             AS severityName,
        string_agg(DISTINCT en.name, ', ') AS entityNames,
        string_agg(DISTINCT op.name, ', ') AS operationNames,
        string_agg(DISTINCT t.name, ', ')  AS tagNames,
        false                              AS deactivated
 FROM validation v
          JOIN validation_entity_operation veo on v.validation_id = veo.validation_id
          JOIN operation op on veo.operation_id = op.operation_id
          JOIN entity en on veo.entity_id = en.entity_id
          JOIN message m on v.message_id = m.message_id
          JOIN severity s on v.severity_id = s.severity_id
          LEFT JOIN validation_tag vt on v.validation_id = vt.validation_id
          LEFT JOIN tag t on vt.tag_id = t.tag_id
 GROUP BY v.validation_id, m.message_id, s.severity_id
 ORDER BY v.validation_id)
) wrapper