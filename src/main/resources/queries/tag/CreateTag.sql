INSERT INTO tag (
    tag_id,
    name,
    description,
    commentary
) VALUES (
    md5(random()::text || now()::text)::varchar,
    :name,
    :description,
    :commentary
)
