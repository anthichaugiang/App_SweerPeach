package com.example.sweet_peach_be.repositories;

import com.example.sweet_peach_be.models.UserFollowedComics;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserFollowedComicRepository extends JpaRepository<UserFollowedComics, Long> {
    List<UserFollowedComics> findByUserIdAndIsDeletedFalse(Long userId);

    UserFollowedComics findByUserIdAndComicId(Long userId, Long comicId);
}
