package com.example.sweet_peach_be.models;

import jakarta.persistence.*;

@Entity
@Table(name = "chapter_images")
public class ChapterImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chapter_image_id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "chapter_id")
    private Chapter chapter;

    private String imagePath;
    private boolean isDeleted;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }



    public void setChapter(Chapter chapter) {
        this.chapter = chapter;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }



    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }
}