package com.example.sweet_peach_be.services;

import com.example.sweet_peach_be.dtos.ComicListItem;
import com.example.sweet_peach_be.models.UserReadingHistory;

import java.util.List;
import java.util.Map;

public interface IUserReadingHistoryService {
    void saveReadingHistory(Long userId, Long comicId, Long chapterId);
    List<UserReadingHistory> getReadingHistory(Long userId);

    Map<Long, Long> getLatestReadChaptersByUserIdAndComicId(Long userId);
}

