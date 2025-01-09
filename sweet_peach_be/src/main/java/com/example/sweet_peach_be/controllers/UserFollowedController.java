package com.example.sweet_peach_be.controllers;

import com.example.sweet_peach_be.models.Comic;
import com.example.sweet_peach_be.models.UserFollowedComics;
import com.example.sweet_peach_be.services.impl.UserFollowedComicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user")
public class UserFollowedController {
    @Autowired
    UserFollowedComicService userFollowed;
    @GetMapping("/{userId}")
    public ResponseEntity<List<Comic>> getFollowedComicsByUserId(@PathVariable Long userId) {
        List<Comic> followedComics = userFollowed.getFollowedComicsByUserId(userId);
        return new ResponseEntity<>(followedComics, HttpStatus.OK);
    }
    @PostMapping("/{userId}/follow/{comicId}")
    public UserFollowedComics followComic(@PathVariable Long userId, @PathVariable Long comicId) {
        return userFollowed.followComic(userId, comicId);
    }
    @DeleteMapping("/{userId}/unfollow/{comicId}")
    public void unfollowComic(@PathVariable Long userId, @PathVariable Long comicId) {
        userFollowed.unfollowComic(userId, comicId);
    }
}
