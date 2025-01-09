package com.example.sweet_peach_be.dtos;


import com.example.sweet_peach_be.models.User;

public class LoginResponse {
    private String token;
    private User user;

    public LoginResponse() {
    }

    public LoginResponse(String token) {
        this.token = token;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}

