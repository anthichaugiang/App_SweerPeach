package com.example.sweet_peach_be.repositories;

import com.example.sweet_peach_be.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // Tìm người dùng theo ID và kiểm tra xem họ đã bị ẩn hay chưa
    Optional<User> findByIdAndIsDeletedFalse(Long userId);

    // Tìm tất cả người dùng không bị ẩn
    List<User> findByIsDeletedFalse();

    // Kiểm tra xem một địa chỉ email đã tồn tại trong cơ sở dữ liệu hay chưa
    boolean existsByEmail(String email);

    User findByEmailAndPasswordAndIsDeletedFalse(String email, String password);

    User findByEmail(String email);
}
