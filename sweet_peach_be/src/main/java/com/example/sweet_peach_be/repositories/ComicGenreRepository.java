package com.example.sweet_peach_be.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.sweet_peach_be.models.ComicGenre;
import java.util.List;

@Repository
public interface ComicGenreRepository extends JpaRepository<ComicGenre, Long> {
    List<ComicGenre> findByComicId(Long comicId);
    List<ComicGenre> findByGenreId(Long genreId);
    void deleteComicGenresByComicId(Long comicId);
    // Các phương thức tùy chỉnh khác nếu cần
}
