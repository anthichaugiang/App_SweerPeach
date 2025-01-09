
package com.example.sweet_peach_be.services.impl;

import com.example.sweet_peach_be.dtos.CommentInfo;
import com.example.sweet_peach_be.models.Comment;
import com.example.sweet_peach_be.models.User;
import com.example.sweet_peach_be.repositories.CommentRepository;
import com.example.sweet_peach_be.repositories.UserRepository;
import com.example.sweet_peach_be.services.ICommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@Service
public class CommentService implements ICommentService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    @Autowired
    public CommentService(CommentRepository commentRepository, UserRepository userRepository) {
        this.commentRepository = commentRepository;
        this.userRepository = userRepository;
    }

    @Override
    public List<CommentInfo> getAllCommentInfo() {
        List<Comment> comments = commentRepository.findAllByIsDeletedFalse();
        return convertToCommentInfoList(comments);
    }
    @Override
    public List<CommentInfo> getAllCommentInfoByChapterId(Long chapterId) {
        List<Comment> comments = commentRepository.findByChapterIdAndIsDeletedFalse(chapterId);

        // Sắp xếp danh sách bình luận theo ID giảm dần
        Collections.sort(comments, new Comparator<Comment>() {
            @Override
            public int compare(Comment c1, Comment c2) {
                return c2.getId().compareTo(c1.getId());
            }
        });

        return convertToCommentInfoList(comments);
    }

    @Override
    public Comment addComment(Comment comment) {
        return commentRepository.save(comment);
    }

    private List<CommentInfo> convertToCommentInfoList(List<Comment> comments) {
        List<CommentInfo> commentInfos = new ArrayList<>();

        for (Comment comment : comments) {
            commentInfos.add(convertToCommentInfo(comment));
        }

        return commentInfos;
    }

    private CommentInfo convertToCommentInfo(Comment comment) {
        CommentInfo commentInfo = new CommentInfo();
        commentInfo.setUserId(comment.getUserId()); // Lấy userId từ comment

        // Truy vấn thông tin người dùng từ userId
        User user = userRepository.findById(comment.getUserId()).orElse(null);
        commentInfo.setUsername(user.getUsername());
        commentInfo.setAvatar(user.getAvatarPath());
        commentInfo.setComicId(comment.getComicId());
        commentInfo.setChapterId(comment.getChapterId());
        commentInfo.setContent(comment.getContent());
        commentInfo.setCreatedAt(comment.getCreatedAt());

        return commentInfo;
    }

}
