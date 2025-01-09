package com.example.sweet_peach_be.services.impl;

import com.example.sweet_peach_be.dtos.TopGenreDto;
import com.example.sweet_peach_be.models.Genre;
import com.example.sweet_peach_be.repositories.CommentRepository;
import com.example.sweet_peach_be.repositories.GenreRepository;
import com.example.sweet_peach_be.services.IGenreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class GenreService implements IGenreService {

    @Autowired
    private GenreRepository genreRepository;
    @Autowired
    public GenreService(GenreRepository genreRepository) {
        this.genreRepository = genreRepository;

    }
    public List<Genre> getAllGenres() {
        List<Genre> allGenres = genreRepository.findAll();
        return allGenres.stream()
                .filter(genre -> !genre.isDeleted())
                .collect(Collectors.toList());
    
    }

    public Optional<Genre> getGenreById(Long id) {
        return genreRepository.findByIdAndIsDeletedFalse(id);
    }
    @Override
    public List<Genre> getGenresByIds(List<Long> ids) {
        return genreRepository.findByIdInAndIsDeletedFalse(ids);
    }
    public Genre saveGenre(Genre genre) {
        Optional<Genre> existingGenre = genreRepository.findByNameAndIsDeletedFalse(genre.getName());
        return existingGenre.orElseGet(() -> genreRepository.save(genre));
    }

    public Genre updateGenre(Genre genre) {
        Optional<Genre> existingGenre = genreRepository.findByIdAndIsDeletedFalse(genre.getId());
        if (existingGenre.isPresent()) {
            Genre existing = existingGenre.get();
            if (!existing.getName().equals(genre.getName())) {
                Optional<Genre> newGenre = genreRepository.findByNameAndIsDeletedFalse(genre.getName());
                if (newGenre.isPresent()) {
                    return existing;
                }
            }
            existing.setName(genre.getName());
            return genreRepository.save(existing);
        }
        return null;
    }

    public void hideGenre(Long id) {
        Optional<Genre> genreOptional = genreRepository.findById(id);
        if (genreOptional.isPresent()) {
            Genre genre = genreOptional.get();
            genre.setDeleted(true);
            genreRepository.save(genre);
        }
    }
    public List<TopGenreDto> getTop6GenresByViewCount() {
        return genreRepository.findTop6GenresByViewCount();
    }
}

