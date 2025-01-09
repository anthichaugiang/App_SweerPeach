package com.example.sweet_peach_be.services.impl;

import com.example.sweet_peach_be.models.UserReadingHistory;
import com.example.sweet_peach_be.repositories.UserReadingHistoryRepository;
import com.example.sweet_peach_be.services.IUserReadingHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class UserReadingHistoryService implements IUserReadingHistoryService{

    @Autowired
    private UserReadingHistoryRepository historyRepository;

    @Override
    public void saveReadingHistory(Long userId, Long comicId, Long chapterId) {
        Optional<UserReadingHistory> existingHistory = historyRepository.findByUserIdAndComicIdAndChapterId(userId, comicId, chapterId);
        if (existingHistory.isPresent()) {
            // Nếu đã tồn tại, cập nhật thời gian mới
            UserReadingHistory historyToUpdate = existingHistory.get();
            historyToUpdate.setTimestamp(LocalDateTime.now());
            historyRepository.save(historyToUpdate);
        } else {
            // Nếu chưa tồn tại, tạo mới và lưu vào cơ sở dữ liệu
            UserReadingHistory history = new UserReadingHistory();
            history.setUserId(userId);
            history.setComicId(comicId);
            history.setChapterId(chapterId);
            history.setDeleted(false);
            history.setTimestamp(LocalDateTime.now());
            historyRepository.save(history);
        }
    }

    @Override
    public List<UserReadingHistory> getReadingHistory(Long userId) {
        return historyRepository.findByUserIdOrderByTimestampDesc(userId);
    }
    @Override
    public Map<Long, Long> getLatestReadChaptersByUserIdAndComicId(Long userId) {
        List<UserReadingHistory> readingHistory = historyRepository.findByUserId(userId);

        // Lọc ra lịch sử đọc theo comicId và tìm chapter gần đây nhất cho mỗi truyện
        Map<Long, Long> latestReadChaptersByComicId = readingHistory.stream()
                .collect(Collectors.groupingBy(UserReadingHistory::getComicId, Collectors.maxBy(Comparator.comparing(UserReadingHistory::getTimestamp))))
                .entrySet().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, entry -> entry.getValue().map(UserReadingHistory::getChapterId).orElse(null)));

        return latestReadChaptersByComicId;
    }

    public LocalDateTime getLatestReadTimestamp(Long userId, Long comicId) {
        List<UserReadingHistory> readingHistory = getReadingHistory(userId);
        return readingHistory.stream()
                .filter(history -> history.getComicId().equals(comicId))
                .map(UserReadingHistory::getTimestamp)
                .max(LocalDateTime::compareTo)
                .orElse(null);
    }

}