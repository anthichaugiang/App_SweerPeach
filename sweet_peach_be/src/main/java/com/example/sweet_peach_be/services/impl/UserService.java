
package com.example.sweet_peach_be.services.impl;

import com.example.sweet_peach_be.exceptions.ResourceNotFoundException;
import com.example.sweet_peach_be.models.User;
import com.example.sweet_peach_be.repositories.UserRepository;
import com.example.sweet_peach_be.services.IEmailService;
import com.example.sweet_peach_be.services.IUserService;
import com.example.sweet_peach_be.services.JwtService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Optional;

@Service
public class UserService implements IUserService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private IEmailService emailService;
    @Autowired
    private JwtService jwtService;

    public List<User> getAllUsers() {
        return userRepository.findByIsDeletedFalse();
    }

    @Override
    public String getUserId(String email) throws ResourceNotFoundException {
        // Thực hiện logic để lấy userId từ email
        // Ví dụ:
        User user = userRepository.findByEmail(email);
        if (user != null) {
            return String.valueOf(user.getId()); // Chuyển đổi Long sang String
        } else {
            throw new ResourceNotFoundException("User not found with email: " + email);
        }
    }

    @Override
    public void verifyEmail(String token) {

    }

    @Override
    public Optional<User> getUserById(Long userId) {
        return userRepository.findByIdAndIsDeletedFalse(userId);
    }
    @Override
    public void changeAvatar(Long userId, String newAvatarPath) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + userId));
        user.setAvatarPath(newAvatarPath);
        userRepository.save(user);
    }
    public User createUser(User user) {
        // Kiểm tra xem người dùng đã tồn tại hay chưa
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        // Lưu người dùng vào cơ sở dữ liệu
        return userRepository.save(user);
    }

    public User updateUser(Long userId, User userDetails) {
        User user = userRepository.findByIdAndIsDeletedFalse(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id " + userId));

        // Update user details
        user.setUsername(userDetails.getUsername());
        user.setEmail(userDetails.getEmail());
        user.setPassword(userDetails.getPassword());

        // Save and return updated user
        return userRepository.save(user);
    }

    public void deleteUser(Long userId) {
        User user = userRepository.findByIdAndIsDeletedFalse(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id " + userId));
        user.setDeleted(true);
        userRepository.save(user);
    }

    public String login(String email, String password) {
        User user = userRepository.findByEmailAndPasswordAndIsDeletedFalse(email, password);
        if (user == null) {
            throw new ResourceNotFoundException("Invalid email or password");
        }
        return jwtService.generateToken(email);
    }
    @Override
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId).orElse(null);
        if (user != null && user.getPassword().equals(oldPassword)) {
            user.setPassword(newPassword);
            userRepository.save(user);
            return true;
        } else {
            return false;
        }
    }



    @Value("${server.port}")
    private String serverPort;
    @Override
    public String resetPassword(String email) {
        String url="http://localhost:"+serverPort+"/reset-password?email=";
        User user = userRepository.findByEmail(email);
        if (user == null) {
            return "Email chưa được đăng ký.";
        } else {
            // Gửi email với form reset password
            String resetLink = url + email;
            String mailContent = "Chào bạn,\n\nBạn có thể đặt lại mật khẩu của mình bằng cách truy cập đường dẫn sau: " + resetLink;
            emailService.sendEmail(email, "Reset Password", mailContent);
            return "Một email đã được gửi đến địa chỉ email của bạn. Vui lòng kiểm tra email để đặt lại mật khẩu.";
        }
    }
    @Override
    public void updatePassword(String email, String newPassword) {
        User user = userRepository.findByEmail(email);
        if (user != null) {
            user.setPassword(newPassword);
            userRepository.save(user);
        }
    }
}
