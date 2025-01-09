
package com.example.sweet_peach_be.services;

import com.example.sweet_peach_be.dtos.ComicListItem;
import com.example.sweet_peach_be.models.Chapter;
import com.example.sweet_peach_be.models.Comic;

import com.example.sweet_peach_be.models.Genre;
import jakarta.transaction.Transactional;

import com.example.sweet_peach_be.models.UserFollowedComics;


import java.util.List;
import java.util.Map;

public interface IComicService {
    List<Comic> getAllComics();

    Comic createComic(Comic comic);

    @Transactional
    void updateComicWithGenres(Long comicId, List<Long> newGenreIds);

    Comic updateComic(Long id, Comic comic);

    List<Chapter> getChaptersByComicId(Long id);

    void deleteComic(Long id);

    List<ComicListItem> getAllComicItems();

    List<ComicListItem> getNewestComicItems(int limit);
    List<ComicListItem> getHotComicItems(String period, int limit);

  //  List<ComicListItem> getFollowedComicsByUserIdItem(Long userId);

    List<ComicListItem> getFollowedComicsByUserIdItem(Long userId);

    List<ComicListItem> getComicHistory(Long userId);

    List<ComicListItem> getLocalStorageItem(List<Map<String, Long>> comicChapterList);

    List<ComicListItem> getComicItemsByGenreId(Long genreId);
    List<Comic> getNewestComics(int limit);

    List<Comic> getHotComics(String period, int limit);
    List<Comic> getComicsByGenreId(Long genreId);
    Comic getComicById(Long id);

    List<Comic> getReadComicsByUserId(Long userId);

    void addGenreToComic(Long comicId, Long genreId);
    List<Genre> getGenresByComicId(Long comicId);
    void insertComicWithGenres(Comic comic, List<Long> genreIds);
    void removeGenreFromComic(Long comicId, Long genreId);

}
