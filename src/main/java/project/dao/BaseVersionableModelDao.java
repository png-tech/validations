package project.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetails;

import project.model.AbstractModel;
import project.model.BaseVersionableModel;
import project.model.Change;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
import java.sql.Timestamp;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/** Базовый класс DAO для моделей по которым ведется история. */
public abstract class BaseVersionableModelDao<MODEL extends BaseVersionableModel> implements AbstractDao<MODEL> {

    private final DataSource ds;

    protected NamedParameterJdbcTemplate jdbc;

    protected RowMapper<Change> changeMapper = (rs, rowNum) -> new Change(rs.getString("id"), ZonedDateTime.ofInstant(rs.getTimestamp("date").toInstant(), ZoneId.systemDefault()), rs.getString("username"), rs.getString("commentary"));

    @Autowired
    public BaseVersionableModelDao(DataSource ds) {
        this.ds = ds;
    }

    @PostConstruct
    public void init() {
        jdbc = new NamedParameterJdbcTemplate(ds);
    }

    protected Map<String, Object> prepareParams(MODEL model) {
        Map<String, Object> params = new HashMap<>();
        params.put("id", model.getId());
        params.put("version", model.getVersion());
        params.put("commentary", model.getCommentary());

        return params;
    }

    protected Map<String, Object> prepareHistoricalParams(MODEL model) {
        Map<String, Object> params = prepareParams(model);
        params.put("date", Timestamp.from(ZonedDateTime.now().toInstant()));
        params.put("version", model.getVersion() + 1);

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        WebAuthenticationDetails details = (WebAuthenticationDetails) authentication.getDetails();
        params.put("username", authentication.getName());
        params.put("ip", details.getRemoteAddress());

        return params;
    }

    protected List<String> ids(List<? extends BaseVersionableModel> models) {
        return models.stream()
                .filter(Objects::nonNull)
                .map(AbstractModel::getId)
                .collect(Collectors.toList());
    }

    protected String id(BaseVersionableModel model) {
        return model == null ? null : model.getId();
    }

    /** Получаем список изменений по конкретной модели данных. */
    public abstract List<Change> getChanges(String id);

    /** Загрузка версии модели. */
    public abstract MODEL loadVersion(int versionId);


}
