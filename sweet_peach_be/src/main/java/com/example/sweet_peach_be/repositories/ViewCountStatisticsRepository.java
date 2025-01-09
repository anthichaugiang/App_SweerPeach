package com.example.sweet_peach_be.repositories;

import com.example.sweet_peach_be.models.ViewCountStatistics;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface ViewCountStatisticsRepository extends JpaRepository<ViewCountStatistics, Long> {
    List<ViewCountStatistics> findByViewDate(LocalDate date);

    List<ViewCountStatistics> findByViewDateBetween(LocalDate startDate, LocalDate endDate);

    ViewCountStatistics findByComicIdAndViewDate(Long id, LocalDate today);

    List<ViewCountStatistics> findByViewDateAfter(LocalDate startDate);
}

