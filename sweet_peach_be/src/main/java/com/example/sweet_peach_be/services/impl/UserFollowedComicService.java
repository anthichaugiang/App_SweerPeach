package com.example.sweet_peach_be.services.impl;


import com.example.sweet_peach_be.models.Comic;
import com.example.sweet_peach_be.models.UserFollowedComics;
import com.example.sweet_peach_be.repositories.UserFollowedComicRepository;
import com.example.sweet_peach_be.services.IUserFollowedComicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserFollowedComicService implements IUserFollowedComicService {

    @Autowired
    private UserFollowedComicRepository userFollowedComicsRepository;
    @Autowired
    private ComicService comicService;
    @Override
    public List<Comic> getFollowedComicsByUserId(Long userId) {
        List<UserFollowedComics> userFollowedComicsList = userFollowedComicsRepository.findByUserIdAndIsDeletedFalse(userId);
        List<Comic> followedComics = new ArrayList<>();

        for (UserFollowedComics userFollowedComics : userFollowedComicsList) {
            Comic comic = comicService.getComicById(userFollowedComics.getComicId());
            if (comic != null) {
                followedComics.add(comic);
            }
        }

        return followedComics;
    }

    @Override
    public UserFollowedComics followComic(Long userId, Long comicId) {
        // Check if the user already follows the comic
        UserFollowedComics existingRecord = userFollowedComicsRepository.findByUserIdAndComicId(userId, comicId);
        if (existingRecord != null) {
            existingRecord.setDeleted(false); // Unhide the record
            comicService.incrementFollowCount(comicId); // Increment follow count
            return userFollowedComicsRepository.save(existingRecord);
        } else {
            // Create a new record
            UserFollowedComics newRecord = new UserFollowedComics();
            newRecord.setUserId(userId);
            newRecord.setComicId(comicId);
            newRecord.setDeleted(false);
            comicService.incrementFollowCount(comicId); // Increment follow count
            return userFollowedComicsRepository.save(newRecord);
        }
    }

    @Override
    public void unfollowComic(Long userId, Long comicId) {
        UserFollowedComics existingRecord = userFollowedComicsRepository.findByUserIdAndComicId(userId, comicId);
        if (existingRecord != null) {
            existingRecord.setDeleted(true); // Hide the record
            comicService.decrementFollowCount(comicId); // Decrement follow count
            userFollowedComicsRepository.save(existingRecord);
        }
    }


}
