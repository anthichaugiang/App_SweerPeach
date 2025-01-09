
package com.example.sweet_peach_be.services.impl;

import com.example.sweet_peach_be.models.ChapterImage;
import com.example.sweet_peach_be.models.Comic;
import com.example.sweet_peach_be.repositories.ComicRepository;
import com.example.sweet_peach_be.services.IChapterService;
import com.example.sweet_peach_be.services.UploadService;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.sweet_peach_be.models.Chapter;
import com.example.sweet_peach_be.repositories.ChapterRepository;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class ChapterService implements IChapterService {

    @Autowired
    private  ChapterRepository chapterRepository;
    @Autowired
    private  ComicRepository comicRepository;
    @Autowired
    private ChapterImageService chapterImageService;
    @Autowired
    private UploadService uploadService;
    private  ComicService comicService;
    private final ViewCountService viewCountService;

    @Autowired
    public ChapterService(ChapterRepository chapterRepository, ComicRepository comicRepository,ViewCountService viewCountService) {
        this.chapterRepository = chapterRepository;
        this.comicRepository = comicRepository;
        this.viewCountService= viewCountService;
    }

    public List<Chapter> getAllChapters() {
        return chapterRepository.findByIsDeletedFalse();
    }
    // Lấy thông tin Chapter theo comicId và chapterId
    public Optional<Chapter> getChapterByComicAndId(Long comicId, Long chapterId) {
        return chapterRepository.findByComicIdAndId(comicId, chapterId);
    }
    @Override
    public Chapter createChapter(Long comicId, Chapter chapter) {
        // Find the corresponding comic by comicId
        Comic comic = comicRepository.findById(comicId)
                .orElseThrow(() -> new RuntimeException("Comic not found with id: " + comicId));

        // Set the comic for the chapter
        chapter.setComic(comic);
        chapter.setUpdatedAt(LocalDateTime.now());

        return chapterRepository.save(chapter);
    }
    public Chapter updateChapter(Long id, Chapter updatedChapter) {
        Chapter existingChapter = chapterRepository.findById(id).orElse(null);
        if (existingChapter != null) {
            existingChapter.setTitle(updatedChapter.getTitle());
            existingChapter.setChapterNumber(updatedChapter.getChapterNumber());
            existingChapter.setUpdatedAt(LocalDateTime.now());
            // Cập nhật các trường khác nếu cần
            return chapterRepository.save(existingChapter);
        }
        return null;
    }

    public void deleteChapter(Long id) {
        Chapter chapter = chapterRepository.findById(id).orElse(null);
        if (chapter != null) {
            chapter.setDeleted(true);
            chapterRepository.save(chapter);
        }
    }

    public Optional<Chapter> getChapterById(Long id) {
        return chapterRepository.findById(id);
    }
    public String getComicTitleByChapterId(Long chapterId) {
        Long comicId = chapterRepository.findComicIdByChapterId(chapterId);
        return comicService.getComicTitle(comicId);
    }
    @Override
    public List<Chapter> getChaptersByComicId(Long comicId) {
        return chapterRepository.findByComicIdAndIsDeletedFalse(comicId);
    }
    @Override
    public Chapter incrementViewCount(Long id) {
        Chapter chapter = chapterRepository.findById(id).orElse(null);
        if (chapter != null) {
            int currentViewCount = chapter.getViewCount();
            chapter.setViewCount(currentViewCount + 1);
            chapter = chapterRepository.save(chapter);


            Comic comic = comicRepository.findById(chapter.getComicId()).orElse(null);
            if (comic != null) {
                comic.setViewCount(comic.getViewCount() + 1);
                comicRepository.save(comic);

                viewCountService.updateComicViewCount(comic);
            }

            return chapter;
        }
        return null;
    }

}
