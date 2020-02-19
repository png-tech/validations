package project.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.dao.entity.EntityDao;
import project.model.Change;
import project.model.entity.Entity;
import project.model.query.SearchParams;

import java.util.List;

@Service
@Transactional
public class EntityServiceImpl implements EntityService {

    private final EntityDao dao;

    @Autowired
    public EntityServiceImpl(EntityDao dao) {
        this.dao = dao;
    }

    @Override
    public Entity load(String entityId) {
        return dao.load(entityId);
    }

    @Override
    public void create(Entity entity) {
        dao.create(entity);
    }

    @Override
    public void update(Entity entity) {
        if(entity.isDeactivated()) {
            dao.updateDeactivated(entity);
        } else {
            dao.update(entity);
        }
    }

    @Override
    public void remove(Entity entity) {
        dao.remove(entity);
    }

    @Override
    public List<Entity> find(SearchParams searchParams) {
        return dao.find(searchParams);
    }

    @Override
    public List<Change> getChanges(String entityId) {
        return dao.getChanges(entityId);
    }

    @Override
    public Entity loadVersion(int versionId) {
        return dao.loadVersion(versionId);
    }

}
