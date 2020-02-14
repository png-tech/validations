SELECT vh2.validation_id                  AS id,
       vh2.description                    AS description,
       vh2.version                        AS version,
       vh2.commentary                     AS commentary,

       vh2.severity_id                      AS severityId,

       mh.message_id                      AS m_id,
       mh.text                            AS m_text,
       mh.version                         AS m_version,
       mh.commentary                      AS m_commentary,

       v.validation_id is null            AS deactivated
FROM (SELECT vh.validation_id AS id,
             MAX(vh.version)  AS version
      FROM validation_h vh
      GROUP BY vh.validation_id) AS maxVersions
         JOIN validation_h vh2 on vh2.validation_id = maxVersions.id AND vh2.version = maxVersions.version
         LEFT JOIN validation v on vh2.validation_id = v.validation_id
         JOIN message_h mh on vh2.message_version_id = mh.message_version_id
WHERE vh2.validation_id IN (:ids)
GROUP BY vh2.validation_version_id, mh.message_version_id, v.validation_id, vh2.validation_id
ORDER BY vh2.validation_id