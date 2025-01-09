package com.example.sweet_peach_be.services;

import com.example.sweet_peach_be.models.Comic;
import com.example.sweet_peach_be.models.UserFollowedComics;

import java.util.List;

public interface IUserFollowedComicService {

    List<Comic> getFollowedComicsByUserId(Long userId);
    UserFollowedComics followComic(Long userId, Long comicId);

    void unfollowComic(Long userId, Long comicId);
}
