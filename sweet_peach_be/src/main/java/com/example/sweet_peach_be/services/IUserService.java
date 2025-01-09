package com.example.sweet_peach_be.services;

import com.example.sweet_peach_be.exceptions.ResourceNotFoundException;
import com.example.sweet_peach_be.models.User;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Optional;

public interface IUserService {
    List<User> getAllUsers();
    Optional<User> getUserById(Long userId);

    void changeAvatar(Long userId, String newAvatarPath);

    User createUser(User user);
    User updateUser(Long userId, User userDetails);
    void deleteUser(Long userId);
    String login(String email, String password);
    String getUserId(String email) throws ResourceNotFoundException;



    void verifyEmail(String token);


    boolean changePassword(Long userId, String oldPassword, String newPassword);

    String resetPassword(String email);

    void updatePassword(String email, String newPassword);
}

