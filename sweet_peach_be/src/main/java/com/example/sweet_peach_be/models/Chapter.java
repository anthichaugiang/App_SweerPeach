package com.example.sweet_peach_be.models;
import com.fasterxml.jackson.annotation.*;
import jakarta.persistence.*;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
@Entity
@Table(name = "chapters")
public class Chapter {
    @Id
    @Column(name = "chapter_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "comic_id")

    private Comic comic;

    @Column(name = "comic_id", insertable = false, updatable = false)
    private Long comicId;
    private String title;
    private int chapterNumber;
    private int viewCount;
    private boolean isDeleted;
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "chapter", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ChapterImage> chapterImages = new ArrayList<>();
    public Long getId() {
        return id;
    }

    public List<ChapterImage> getChapterImages() {
        return chapterImages;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getComic() {
        return comic.getTitle();
    }

    public void setComic(Comic comic) {
        this.comic = comic;
    }

    public Long getComicId() {
        return comicId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getChapterNumber() {
        return chapterNumber;
    }

    public void setChapterNumber(int chapterNumber) {
        this.chapterNumber = chapterNumber;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public void setComicId(Long comicId) {
        this.comicId = comicId;
    }


    public void setChapterImages(List<ChapterImage> chapterImages) {
        this.chapterImages = chapterImages;
    }

}