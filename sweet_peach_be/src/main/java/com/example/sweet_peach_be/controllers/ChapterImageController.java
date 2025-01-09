package com.example.sweet_peach_be.controllers;

import com.example.sweet_peach_be.models.ChapterImage;
import com.example.sweet_peach_be.services.impl.ChapterImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/chapterImages")
@CrossOrigin
public class ChapterImageController {
    @Autowired
    private ChapterImageService chapterImageService;

    @Autowired
    public ChapterImageController(ChapterImageService chapterImageService) {
        this.chapterImageService = chapterImageService;
    }

    @GetMapping("/chapter/{chapterId}")
    public ResponseEntity<List<ChapterImage>> getChapterImagesByChapterId(@PathVariable Long chapterId) {
        List<ChapterImage> chapterImages = chapterImageService.getChapterImagesByChapterId(chapterId);
        return ResponseEntity.ok(chapterImages);
    }
    @PostMapping("/create/{chapterId}")
    public ResponseEntity<ChapterImage> addChapterImage(@PathVariable Long chapterId, @RequestParam("file") MultipartFile file) throws IOException {
        ChapterImage chapterImage = chapterImageService.addChapterImage(chapterId, file);
        return ResponseEntity.status(HttpStatus.CREATED).body(chapterImage);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteChapterImage(@PathVariable Long id) {
        chapterImageService.deleteChapterImage(id);
        return ResponseEntity.noContent().build();
    }
}