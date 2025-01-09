package com.example.sweet_peach_be.services.impl;

import com.example.sweet_peach_be.models.Chapter;
import com.example.sweet_peach_be.models.ChapterImage;
import com.example.sweet_peach_be.repositories.ChapterImageRepository;
import com.example.sweet_peach_be.repositories.ChapterRepository;
import com.example.sweet_peach_be.services.UploadService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;


import java.io.IOException;
import java.util.List;

@Service
public class ChapterImageService {
    @Autowired
    private ChapterImageRepository chapterImageRepository;
    @Autowired
    private ChapterRepository chapterRepository;

    @Autowired
    private UploadService uploadService;
    @Autowired
    public ChapterImageService(ChapterImageRepository chapterImageRepository) {
        this.chapterImageRepository = chapterImageRepository;
    }

    public List<ChapterImage> getChapterImagesByChapterId(Long chapterId) {
        return chapterImageRepository.findByChapterId(chapterId);
    }

    public ChapterImage addChapterImage(Long chapterId, MultipartFile file) throws IOException {
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new EntityNotFoundException("Chapter not found with id: " + chapterId));

        String imagePath = uploadService.storeImage(file);

        ChapterImage chapterImage = new ChapterImage();
        chapterImage.setChapter(chapter);
        chapterImage.setImagePath(imagePath);

        return chapterImageRepository.save(chapterImage);
    }

    public void deleteChapterImage(Long id) {
        ChapterImage chapterImage = chapterImageRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Chapter Image not found with id: " + id));

        chapterImageRepository.delete(chapterImage);
    }
}