
package com.example.sweet_peach_be.repositories;

import com.example.sweet_peach_be.models.Chapter;
import com.example.sweet_peach_be.models.Comic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ComicRepository extends JpaRepository<Comic, Long> {
    List<Comic> findAllByIsDeletedFalse();

    List<Comic> findByIsDeletedFalseAndGenresId(Long genreId);
    Optional<Object> findByIsDeletedFalseAndId(Long id);

}
