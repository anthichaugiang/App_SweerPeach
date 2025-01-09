package com.example.sweet_peach_be.dtos;

import com.example.sweet_peach_be.models.Genre;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

@JsonSerialize(using = TopGenreDtoSerializer.class)

public class TopGenreDto {

    private Genre genre;
    private long totalViewCount;

    public TopGenreDto(Genre genre, long totalViewCount) {
        this.genre = genre;
        this.totalViewCount = totalViewCount;
    }

    public Genre getGenre() {
        return genre;
    }
    public long getGenreId() {
        return genre.getId(); // Sử dụng phương thức getName() của đối tượng Genre để lấy tên thể loại
    }
    public String getGenreName() {
        return genre.getName(); // Sử dụng phương thức getName() của đối tượng Genre để lấy tên thể loại
    }
    public void setGenre(Genre genre) {
        this.genre = genre;
    }

    public long getTotalViewCount() {
        return totalViewCount;
    }

    public void setTotalViewCount(long totalViewCount) {
        this.totalViewCount = totalViewCount;
    }
// Getters and setters
}

