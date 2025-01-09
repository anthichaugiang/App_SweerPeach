package com.example.sweet_peach_be.services;

import com.example.sweet_peach_be.models.Chapter;
import jakarta.transaction.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

public interface IChapterService {
    List<Chapter> getAllChapters();
    Chapter createChapter(Long comicId, Chapter chapter);
    Chapter updateChapter(Long id, Chapter updatedChapter);



    void deleteChapter(Long id);
    List<Chapter>getChaptersByComicId(Long comicId);
    Chapter incrementViewCount(Long id);

    String getComicTitleByChapterId(Long chapterId);

    Optional<Chapter> getChapterById(Long id);

    Optional<Chapter> getChapterByComicAndId(Long comicId, Long chapterId);
}