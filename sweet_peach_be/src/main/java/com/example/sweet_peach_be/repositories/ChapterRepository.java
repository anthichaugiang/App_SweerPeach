package com.example.sweet_peach_be.repositories;

import com.example.sweet_peach_be.models.Chapter;
import com.example.sweet_peach_be.models.Genre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ChapterRepository extends JpaRepository<Chapter, Long> {

    List<Chapter> findByIsDeletedFalse();

    List<Chapter> findByComicIdAndIsDeletedFalse(Long comicId);

    List<Chapter> findByTitleAndIsDeletedFalse(String title);
    // Tìm Chapter theo comicId và chapterId
    Optional<Chapter> findByComicIdAndId(Long comicId, Long id);
    @Query("SELECT c FROM Chapter c ORDER BY c.updatedAt DESC")
    List<Chapter> findTopChaptersOrderByUpdatedAtDesc(@Param("limit") int limit);
    @Query("SELECT c.comic.id FROM Chapter c WHERE c.id = :chapterId")
    Long findComicIdByChapterId(@Param("chapterId") Long chapterId);
    Chapter findFirstByComicIdOrderByChapterNumberDesc(Long id);
}