package com.example.sweet_peach_be.models;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "view_count_statistics")
public class ViewCountStatistics {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="view_id")
    private Long id;

    @Column(name = "comic_id")
    private Long comicId;

    @Column(name = "view_count")
    private int viewCount;

    @Column(name = "view_date")
    private LocalDate viewDate;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getComicId() {
        return comicId;
    }

    public void setComicId(Long comicId) {
        this.comicId = comicId;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public LocalDate getViewDate() {
        return viewDate;
    }

    public void setViewDate(LocalDate viewDate) {
        this.viewDate = viewDate;
    }

    // Constructors, getters, and setters
}
