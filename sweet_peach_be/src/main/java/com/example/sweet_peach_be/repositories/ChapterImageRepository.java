
package com.example.sweet_peach_be.repositories;

import com.example.sweet_peach_be.models.ChapterImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChapterImageRepository extends JpaRepository<ChapterImage, Long> {

    List<ChapterImage> findByChapterId(Long chapterId);
}
