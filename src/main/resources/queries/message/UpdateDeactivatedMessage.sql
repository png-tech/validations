INSERT INTO message (message_id,
                     text,
                     version,
                     commentary)
VALUES (:id,
        :text,
        :version + 1,
        :commentary)