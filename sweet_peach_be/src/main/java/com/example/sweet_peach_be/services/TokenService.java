package com.example.sweet_peach_be.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class TokenService {

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    public void storeToken(String token, long expirationMinutes) {
        redisTemplate.opsForValue().set(token, token, expirationMinutes, TimeUnit.MINUTES);
    }

    public boolean isTokenValid(String token) {
        return redisTemplate.hasKey(token);
    }

    public void removeToken(String token) {
        redisTemplate.delete(token);
    }
    public String getEmailFromToken(String token) {
        return redisTemplate.opsForValue().get(token);
    }
}

