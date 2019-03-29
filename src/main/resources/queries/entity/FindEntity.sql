SELECT * FROM (
  SELECT
    e.entity_id AS id,
    e.name,
    e.description,
    e.version,
    e.commentary
  FROM entity e
  LEFT JOIN tag t ON 1=1
  ORDER BY entity_id
) wrapper