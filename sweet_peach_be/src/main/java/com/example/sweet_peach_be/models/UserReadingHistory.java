
package com.example.sweet_peach_be.models;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_reading_history")
public class UserReadingHistory {
    @Id
    @Column(name="user_reading_history_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "comic_id")
    private Long comicId;

    @Column(name = "chapter_id")
    private Long chapterId;

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    @Column(name = "timestamp")
    private LocalDateTime timestamp;
    @Column(name = "is_deleted")
    private boolean deleted;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getComicId() {
        return comicId;
    }

    public void setComicId(Long comicId) {
        this.comicId = comicId;
    }

    public Long getChapterId() {
        return chapterId;
    }

    public void setChapterId(Long chapterId) {
        this.chapterId = chapterId;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }
}
