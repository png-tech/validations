INSERT INTO tag (tag_id,
                 name,
                 version,
                 description,
                 commentary)
VALUES (:id,
        :name,
        :version + 1,
        :description,
        :commentary)
