SELECT
    vh2.validation_id AS v_id,
    t.tag_id AS id,
    t.name,
    t.version,
    t.description,
    t.commentary,
    t.tag_id is null AS deactivated
FROM (SELECT vh.validation_id AS id,
             MAX(vh.version)  AS maxVersion
      FROM validation_h vh
      GROUP BY vh.validation_id
      ORDER BY vh.validation_id) AS maxVersions
         JOIN validation_h vh2 ON vh2.validation_id = maxVersions.id AND vh2.version = maxVersions.maxVersion
         JOIN validation_tag_h vth ON vh2.validation_version_id = vth.validation_version_id
         JOIN tag_h th2 ON vth.tag_version_id = th2.tag_version_id
         JOIN tag t ON th2.tag_id = t.tag_id
WHERE vh2.validation_id IN (:ids)
