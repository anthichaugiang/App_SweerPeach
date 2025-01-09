package com.example.sweet_peach_be.controllers;

import com.example.sweet_peach_be.models.Chapter;
import com.example.sweet_peach_be.models.ChapterImage;
import com.example.sweet_peach_be.services.IChapterService;
import com.example.sweet_peach_be.services.UploadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RestController
@CrossOrigin
@RequestMapping("/api/chapters")
public class ChapterController {

    private final IChapterService chapterService;
    @Autowired
    private UploadService uploadService;

    @Autowired
    public ChapterController(IChapterService chapterService) {
        this.chapterService = chapterService;
    }

    @GetMapping
    public ResponseEntity<List<Chapter>> getAllChapters() {
        List<Chapter> chapters = chapterService.getAllChapters();
        return new ResponseEntity<>(chapters, HttpStatus.OK);
    }

    @GetMapping("/comic/{comicId}")
    public ResponseEntity<List<Chapter>> getChaptersByComicId(@PathVariable Long comicId) {
        List<Chapter> chapters = chapterService.getChaptersByComicId(comicId);
        return new ResponseEntity<>(chapters, HttpStatus.OK);
    }

    // Lấy thông tin Chapter theo comicId và chapterId
    @GetMapping("/{comicId}/chapters/{chapterId}")
    public ResponseEntity<Chapter> getChapterByComicAndId(@PathVariable Long comicId, @PathVariable Long chapterId) {
        Optional<Chapter> chapter = chapterService.getChapterByComicAndId(comicId, chapterId);
        return chapter.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @GetMapping("/{chapterId}/comicTitle")
    public ResponseEntity<String> getComicTitleByChapterId(@PathVariable Long chapterId) {
        try {
            String comicTitle = chapterService.getComicTitleByChapterId(chapterId);
            if (comicTitle != null) {
                return ResponseEntity.ok(comicTitle);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/create/{comicId}")
    public ResponseEntity<Chapter> createChapterForComic(@PathVariable Long comicId,
                                                         @RequestParam("chapterNumber") int chapterNumber,
                                                         @RequestParam("title") String title

    ) {
        try {
            Chapter chapter = new Chapter();
            chapter.setComicId(comicId);
            chapter.setChapterNumber(chapterNumber);
            chapter.setTitle(title);
            Chapter createdChapter = chapterService.createChapter(comicId, chapter);
            return new ResponseEntity<>(createdChapter, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Chapter> updateChapter(@PathVariable Long id,
                                                 @RequestParam("chapterNumber") int chapterNumber,
                                                 @RequestParam("title") String title

    ) {
        try {
            if (id == null || id <= 0) {
                return new ResponseEntity<>(HttpStatus.BAD_REQUEST); // Trả về lỗi nếu id không hợp lệ
            }

            Optional<Chapter> existingChapter = chapterService.getChapterById(id);
            if (existingChapter.isPresent()) {
                Chapter chapter = existingChapter.get();
                // Giữ nguyên comicId
                Long comicId = chapter.getComicId();
                chapter.setComicId(comicId);
                chapter.setChapterNumber(chapterNumber);
                chapter.setTitle(title);


                Chapter updated = chapterService.updateChapter(id, chapter);
                return new ResponseEntity<>(updated, HttpStatus.OK);
            }
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
        @DeleteMapping("/delete/{id}")
        public ResponseEntity<?> deleteChapter (@PathVariable("id") Long id){
            chapterService.deleteChapter(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }

        @GetMapping("/view/{id}")
        public ResponseEntity<Chapter> incrementViewCount (@PathVariable("id") Long id){
            Chapter chapter = chapterService.incrementViewCount(id);
            if (chapter != null) {
                return new ResponseEntity<>(chapter, HttpStatus.OK);
            }
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

