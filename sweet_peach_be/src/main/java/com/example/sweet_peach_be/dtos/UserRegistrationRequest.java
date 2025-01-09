package com.example.sweet_peach_be.dtos;

import com.example.sweet_peach_be.models.User;

public class UserRegistrationRequest {

    private User user;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getEmail() {
        return user.getEmail();
    }
}

