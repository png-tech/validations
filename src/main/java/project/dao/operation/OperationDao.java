package project.dao.operation;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import project.dao.BaseVersionableModelDao;
import project.dao.ConcurrentModificationException;
import project.dao.FindAbility;
import project.dao.SearchParamsProcessor;
import project.model.Change;
import project.model.operation.Operation;
import project.model.query.SearchParams;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.util.Collections.singletonMap;
import static project.dao.RequestRegistry.lookup;
import static project.dao.SearchParamsProcessor.process;

@Repository
public class OperationDao extends BaseVersionableModelDao<Operation> implements FindAbility<Operation>, OperationValidatorDao {

    private RowMapper<Operation> mapper = (rs, rowNum) -> {
        Operation operation = new Operation(rs.getString("id"), rs.getString("name"), rs.getString("description"), rs.getInt("version"), rs.getString("commentary"));
        operation.setDeactivated(rs.getBoolean("deactivated"));
        return operation;
    };

    public OperationDao(DataSource ds) {
        super(ds);
    }

    public Operation load(String operationId) {
        return jdbc.queryForObject(lookup("operation/LoadOperation"), singletonMap("id", operationId), mapper);
    }

    public void create(Operation operation) {
        jdbc.update(lookup("operation/CreateOperation"), prepareParams(operation));
        createHistory(operation);
    }

    private void createHistory(Operation operation) {
        jdbc.update(lookup("operation/CreateOperationHistory"), prepareHistoricalParams(operation));
    }

    public void update(Operation operation) {
        int rowsAffected = jdbc.update(lookup("operation/UpdateOperation"), prepareParams(operation));
        if (rowsAffected == 0) {
            throw new ConcurrentModificationException();
        }
        createHistory(operation);
    }

    public void updateDeactivated(Operation operation) {
        jdbc.update(lookup("operation/UpdateDeactivatedOperation"), prepareParams(operation));
        createHistory(operation);
    }

    public void remove(Operation operation) {
        int rowsAffected = jdbc.update(lookup("operation/DeleteOperation"), prepareParams(operation));
        if (rowsAffected == 0) {
            throw new ConcurrentModificationException();
        }
        createHistory(operation);
    }

    public List<Operation> find(SearchParams searchParams) {
        SearchParamsProcessor.ProcessResult result = process(lookup("operation/FindOperation"), searchParams);
        return jdbc.query(result.getResultQuery(), result.getParams(), mapper);
    }

    @Override
    protected Map<String, Object> prepareParams(Operation operation) {
        Map<String, Object> params = super.prepareParams(operation);
        params.put("name", operation.getName());
        params.put("description", operation.getDescription());
        return params;
    }

    /** Проверка существования записи в БД с указанным id. */
    public boolean alreadyExists(String id) {
        return jdbc.queryForObject(lookup("operation/AlreadyExists"), singletonMap("id", id), Boolean.class);
    }

    /** Проверка существования записи в БД с указанным наименованием. */
    public boolean nameAlreadyExists(String id, String name) {
        Map<String, String> params = new HashMap<>();
        params.put("id", id);
        params.put("name", name);

        return jdbc.queryForObject(lookup("operation/NameAlreadyExists"), params, Boolean.class);
    }

    /** Проверка что на удаляемую запись ссылаются из других таблиц. */
    public boolean isUsed(String id) {
        return jdbc.queryForObject(lookup("operation/IsUsed"), singletonMap("id", id), Boolean.class);
    }

    public List<Change> getChanges(String id) {
        return jdbc.query(lookup("operation/LoadChanges"), singletonMap("id", id), changeMapper);
    }

    @Override
    public Operation loadVersion(int versionId) {
        return jdbc.queryForObject(lookup("operation/LoadOperationVersion"), singletonMap("id", versionId), mapper);
    }

    @Override
    public String getCurrentCommentary(String operationId) {
        return jdbc.queryForObject(lookup("operation/GetCurrentCommentary"), singletonMap("operationId", operationId), String.class);
    }

}
