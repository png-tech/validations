insert into operation(operation_id,
                      name,
                      version,
                      description,
                      commentary)
values (:id,
        :name,
        :version + 1,
        :description,
        :commentary)