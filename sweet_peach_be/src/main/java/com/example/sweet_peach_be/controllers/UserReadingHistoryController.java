
package com.example.sweet_peach_be.controllers;

import com.example.sweet_peach_be.dtos.ComicListItem;
import com.example.sweet_peach_be.models.UserReadingHistory;
import com.example.sweet_peach_be.services.IComicService;
import com.example.sweet_peach_be.services.IUserReadingHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user/reading-history")
public class UserReadingHistoryController {

    @Autowired
    private IUserReadingHistoryService historyService;
    @Autowired
    private IComicService comicService;


    @GetMapping("/{userId}/last-chapter/{comicId}")
    public Long getLatestReadChapterForComic(@PathVariable Long userId, @PathVariable Long comicId) {
        Map<Long, Long> latestReadChapters = historyService.getLatestReadChaptersByUserIdAndComicId(userId);
        return latestReadChapters.getOrDefault(comicId,null );
    }
    @GetMapping("/{userId}/comics")
    public ResponseEntity<List<ComicListItem>> getReadComicHistory(@PathVariable Long userId) {
        List<ComicListItem> readComics = comicService.getComicHistory(userId);
        if (readComics.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(readComics, HttpStatus.OK);
    }
    @PostMapping
    public ResponseEntity<Void> saveReadingHistory(@RequestBody UserReadingHistory history) {
        historyService.saveReadingHistory(history.getUserId(), history.getComicId(), history.getChapterId());
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @GetMapping("/{userId}")
    public ResponseEntity<List<UserReadingHistory>> getReadingHistory(@PathVariable Long userId) {
        List<UserReadingHistory> history = historyService.getReadingHistory(userId);
        return new ResponseEntity<>(history, HttpStatus.OK);
    }
}
