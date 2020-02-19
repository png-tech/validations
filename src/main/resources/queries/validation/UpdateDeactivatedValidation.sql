INSERT INTO validation (validation_id,
                        version,
                        severity_id,
                        message_id,
                        description,
                        commentary)
VALUES (:id,
        :version + 1,
        :severityId,
        :messageId,
        :description,
        :commentary)