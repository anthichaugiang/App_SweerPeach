package com.example.sweet_peach_be.services;

import com.example.sweet_peach_be.dtos.TopGenreDto;
import com.example.sweet_peach_be.models.Genre;

import java.util.List;
import java.util.Optional;

public interface IGenreService {
    List<Genre> getGenresByIds(List<Long> ids);
    List<Genre> getAllGenres();
    Optional<Genre> getGenreById(Long id);
    Genre saveGenre(Genre genre);
    Genre updateGenre(Genre genre);
    void hideGenre(Long id);
    List<TopGenreDto> getTop6GenresByViewCount();
}

