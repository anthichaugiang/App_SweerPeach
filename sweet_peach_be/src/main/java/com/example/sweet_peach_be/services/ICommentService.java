
package com.example.sweet_peach_be.services;

import com.example.sweet_peach_be.dtos.CommentInfo;
import com.example.sweet_peach_be.models.Comment;

import java.util.List;

public interface ICommentService {
    List<CommentInfo> getAllCommentInfo();

    List<CommentInfo> getAllCommentInfoByChapterId(Long chapterId);

    Comment addComment(Comment comment);
}
