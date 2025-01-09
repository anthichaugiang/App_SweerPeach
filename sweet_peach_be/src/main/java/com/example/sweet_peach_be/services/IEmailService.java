package com.example.sweet_peach_be.services;

public interface IEmailService {
    void sendEmail(String to, String subject, String content);
}
