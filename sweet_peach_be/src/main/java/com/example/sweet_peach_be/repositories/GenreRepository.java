package com.example.sweet_peach_be.repositories;

import com.example.sweet_peach_be.dtos.TopGenreDto;
import com.example.sweet_peach_be.models.Genre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface GenreRepository extends JpaRepository<Genre, Long> {
    Optional<Genre> findByNameAndIsDeletedFalse(String name);
    List<Genre> findByIdInAndIsDeletedFalse(List<Long> ids);
    Optional<Genre> findByIdAndIsDeletedFalse(Long id);
    List<Genre> findByIsDeletedFalse();
    @Query("SELECT NEW com.example.sweet_peach_be.dtos.TopGenreDto(cg.genre, SUM(c.viewCount)) " +
            "FROM ComicGenre cg " +
            "JOIN cg.comic c " +
            "GROUP BY cg.genre " +
            "ORDER BY SUM(c.viewCount) DESC "+
            "LIMIT 6")
    List<TopGenreDto> findTop6GenresByViewCount();

}

