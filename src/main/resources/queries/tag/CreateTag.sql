INSERT INTO tag (
    tag_id,
    name,
    description,
    commentary
) VALUES (
    uuid_generate_v4()::varchar,
    :name,
    :description,
    :commentary
)
