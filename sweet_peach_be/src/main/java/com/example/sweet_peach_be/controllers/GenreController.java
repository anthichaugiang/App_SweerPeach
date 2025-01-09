package com.example.sweet_peach_be.controllers;

import com.example.sweet_peach_be.dtos.TopGenreDto;
import com.example.sweet_peach_be.models.Genre;
import com.example.sweet_peach_be.services.IGenreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/genres")
@CrossOrigin
public class GenreController {

    @Autowired
    private IGenreService genreService;

    @GetMapping
    public ResponseEntity<List<Genre>> getAllGenres() {
        List<Genre> genres = genreService.getAllGenres();
        return new ResponseEntity<>(genres, HttpStatus.OK);
    }
    @GetMapping("/top6")
    public ResponseEntity<List<TopGenreDto>> getTop6GenresByViewCount() {
        List<TopGenreDto> topGenres = genreService.getTop6GenresByViewCount();
        return new ResponseEntity<>(topGenres, HttpStatus.OK);
    }
    @GetMapping("/{id}")
    public ResponseEntity<Genre> getGenreById(@PathVariable Long id) {
        Optional<Genre> genre = genreService.getGenreById(id);
        return genre.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PostMapping("/create")
    public ResponseEntity<Genre> createGenre(@RequestBody Genre genre) {
        Genre createdGenre = genreService.saveGenre(genre);
        return new ResponseEntity<>(createdGenre, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Genre> updateGenre(@PathVariable Long id, @RequestBody Genre genre) {
        Genre updatedGenre = genreService.updateGenre(genre);
        if (updatedGenre != null) {
            return new ResponseEntity<>(updatedGenre, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> hideGenre(@PathVariable Long id) {
        genreService.hideGenre(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}

