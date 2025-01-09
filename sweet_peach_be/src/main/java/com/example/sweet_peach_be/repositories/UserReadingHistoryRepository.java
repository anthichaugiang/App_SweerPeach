package com.example.sweet_peach_be.repositories;

import com.example.sweet_peach_be.models.UserReadingHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserReadingHistoryRepository extends JpaRepository<UserReadingHistory, Long> {
    Optional<UserReadingHistory> findByUserIdAndComicIdAndChapterId(Long userId, Long comicId, Long chapterId);
    List<UserReadingHistory> findByUserIdOrderByTimestampDesc(Long userId);
    List<UserReadingHistory> findByUserId(Long userId);
    // Các phương thức custom nếu cần
}