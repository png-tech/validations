(SELECT vh2.validation_id                  AS id,
        vh2.description                    AS description,
        vh2.version                        AS version,
        vh2.commentary                     AS commentary,

        vh2.severity_id                    AS severityId,

        mh.message_id                      AS m_id,
        mh.text                            AS m_text,
        mh.version                         AS m_version,
        mh.commentary                      AS m_commentary,

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
          LEFT JOIN validation_tag_h vth on vh2.validation_version_id = vth.validation_version_id
          LEFT JOIN tag_h th on vth.tag_version_id = th.tag_version_id
 WHERE vh2.validation_id in (:ids)
 GROUP BY vh2.validation_version_id, mh.message_version_id
 ORDER BY vh2.validation_version_id)
UNION
(SELECT v.validation_id                    AS id,
        v.description                      AS description,
        v.version                          AS version,
        v.commentary                       AS commentary,

        v.severity_id                      AS severityId,

        m.message_id                       AS m_id,
        m.text                             AS m_text,
        m.version                          AS m_version,
        m.commentary                       AS m_commentary,

        string_agg(DISTINCT en.name, ', ') AS entityNames,
        string_agg(DISTINCT op.name, ', ') AS operationNames,
        string_agg(DISTINCT t.name, ', ')  AS tagNames,
        false                              AS deactivated
 FROM validation v
          JOIN validation_entity_operation veo on v.validation_id = veo.validation_id
          JOIN operation op on veo.operation_id = op.operation_id
          JOIN entity en on veo.entity_id = en.entity_id
          JOIN message m on v.message_id = m.message_id
          LEFT JOIN validation_tag vt on v.validation_id = vt.validation_id
          LEFT JOIN tag t on vt.tag_id = t.tag_id
 WHERE v.validation_id in (:ids)
 GROUP BY v.validation_id, m.message_id
 ORDER BY v.validation_id)