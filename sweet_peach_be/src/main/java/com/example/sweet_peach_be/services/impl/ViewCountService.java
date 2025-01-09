package com.example.sweet_peach_be.services.impl;

import com.example.sweet_peach_be.models.Comic;
import com.example.sweet_peach_be.models.ViewCountStatistics;
import com.example.sweet_peach_be.repositories.ViewCountStatisticsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class ViewCountService {
    @Autowired
    private ViewCountStatisticsRepository viewCountStatisticsRepository;

    public void updateComicViewCount(Comic comic) {
        // Kiểm tra xem có bản ghi cho ngày hiện tại đã tồn tại chưa
        LocalDate today = LocalDate.now();
        ViewCountStatistics existingRecord = viewCountStatisticsRepository.findByComicIdAndViewDate(comic.getId(), today);
        if (existingRecord != null) {
            // Nếu đã tồn tại, chỉ cần tăng số lượt xem
            existingRecord.setViewCount(existingRecord.getViewCount() + 1);
            viewCountStatisticsRepository.save(existingRecord);
        } else {
            // Nếu chưa tồn tại, tạo mới bản ghi và lưu vào cơ sở dữ liệu
            ViewCountStatistics viewCountStatistics = new ViewCountStatistics();
            viewCountStatistics.setComicId(comic.getId());
            viewCountStatistics.setViewCount(1);
            viewCountStatistics.setViewDate(today);
            viewCountStatisticsRepository.save(viewCountStatistics);
        }
    }

    public List<ViewCountStatistics> getViewCountStatisticsByDate(LocalDate date) {
        return viewCountStatisticsRepository.findByViewDate(date);
    }

    public List<ViewCountStatistics> getViewCountStatisticsByWeek(LocalDate startDate, LocalDate endDate) {
        return viewCountStatisticsRepository.findByViewDateBetween(startDate, endDate);
    }

    public List<ViewCountStatistics> getViewCountStatisticsByMonth(int year, int month) {
        LocalDate startDate = LocalDate.of(year, month, 1);
        LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());
        return viewCountStatisticsRepository.findByViewDateBetween(startDate, endDate);
    }
}
