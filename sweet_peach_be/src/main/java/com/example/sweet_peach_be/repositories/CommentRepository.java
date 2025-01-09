package com.example.sweet_peach_be.repositories;

import com.example.sweet_peach_be.models.Comment;
import com.example.sweet_peach_be.models.Genre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findAllByIsDeletedFalse();

    List<Comment> findByChapterIdAndIsDeletedFalse(Long chapterId);
}