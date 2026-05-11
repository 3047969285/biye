package com.ruoyi.web.service.tool;

import com.ruoyi.web.controller.tool.UserEntity;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;

@Service
public class TestService {

    private final Map<Integer, UserEntity> users = new LinkedHashMap<>();

    {
        users.put(1, new UserEntity(1, "admin", "admin123", "15888888888"));
        users.put(2, new UserEntity(2, "ry", "admin123", "15666666666"));
    }

    public List<UserEntity> list() {
        return new ArrayList<>(users.values());
    }

    public UserEntity getById(Integer userId) {
        return users.get(userId);
    }

    public void save(UserEntity user) {
        users.put(user.getUserId(), user);
    }

    public void update(UserEntity user) {
        users.remove(user.getUserId());
        users.put(user.getUserId(), user);
    }

    public void delete(Integer userId) {
        users.remove(userId);
    }

    public boolean exists(Integer userId) {
        return users.containsKey(userId);
    }
}
