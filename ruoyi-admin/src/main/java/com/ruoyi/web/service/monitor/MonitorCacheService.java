package com.ruoyi.web.service.monitor;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TreeSet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysCache;

/**
 * 缓存监控 — 封装 Redis 内省操作，供 CacheController 使用
 */
@Service
public class MonitorCacheService {

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    private final List<SysCache> caches = new ArrayList<>();

    {
        caches.add(new SysCache(CacheConstants.LOGIN_TOKEN_KEY, "用户信息"));
        caches.add(new SysCache(CacheConstants.SYS_CONFIG_KEY, "配置信息"));
        caches.add(new SysCache(CacheConstants.SYS_DICT_KEY, "数据字典"));
        caches.add(new SysCache(CacheConstants.CAPTCHA_CODE_KEY, "验证码"));
        caches.add(new SysCache(CacheConstants.REPEAT_SUBMIT_KEY, "防重提交"));
        caches.add(new SysCache(CacheConstants.RATE_LIMIT_KEY, "限流处理"));
        caches.add(new SysCache(CacheConstants.PWD_ERR_CNT_KEY, "密码错误次数"));
    }

    public List<SysCache> getCacheNames() {
        return caches;
    }

    public Map<String, Object> getRedisInfo() {
        Properties info = redisTemplate.execute((RedisCallback<Properties>) connection -> connection.serverCommands().info());
        Properties commandStats = redisTemplate.execute((RedisCallback<Properties>) connection -> connection.serverCommands().info("commandstats"));
        Object dbSize = redisTemplate.execute((RedisCallback<Object>) connection -> connection.serverCommands().dbSize());

        Map<String, Object> result = new HashMap<>(3);
        result.put("info", info);
        result.put("dbSize", dbSize);

        List<Map<String, String>> pieList = new ArrayList<>();
        if (commandStats != null) {
            commandStats.stringPropertyNames().forEach(key -> {
                Map<String, String> data = new HashMap<>(2);
                String property = commandStats.getProperty(key);
                data.put("name", StringUtils.removeStart(key, "cmdstat_"));
                data.put("value", StringUtils.substringBetween(property, "calls=", ",usec"));
                pieList.add(data);
            });
        }
        result.put("commandStats", pieList);
        return result;
    }

    public Set<String> getCacheKeys(String cacheName) {
        Set<String> cacheKeys = redisTemplate.keys(cacheName + "*");
        return new TreeSet<>(cacheKeys);
    }

    public SysCache getCacheValue(String cacheName, String cacheKey) {
        String cacheValue = redisTemplate.opsForValue().get(cacheKey);
        return new SysCache(cacheName, cacheKey, cacheValue);
    }

    public void clearCacheName(String cacheName) {
        Collection<String> cacheKeys = redisTemplate.keys(cacheName + "*");
        redisTemplate.delete(cacheKeys);
    }

    public void clearCacheKey(String cacheKey) {
        redisTemplate.delete(cacheKey);
    }

    public void clearAllCache() {
        Collection<String> cacheKeys = redisTemplate.keys("*");
        redisTemplate.delete(cacheKeys);
    }
}
