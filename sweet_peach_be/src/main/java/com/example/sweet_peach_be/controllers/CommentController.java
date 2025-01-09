
package com.example.sweet_peach_be.controllers;

import com.example.sweet_peach_be.dtos.CommentInfo;
import com.example.sweet_peach_be.models.Comment;

import com.example.sweet_peach_be.services.ICommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/comments")
public class CommentController {

    private final ICommentService commentService;

    @Autowired
    public CommentController(ICommentService commentService) {
        this.commentService = commentService;
    }

    @PostMapping("/add")
    public Comment addComment(@RequestBody Comment comment) {
        // Thêm mới comment
        return commentService.addComment(comment);
    }

    @GetMapping("/all")
    public List<CommentInfo> getAllComments() {
        // Lấy ra tất cả thông tin các comment
        return commentService.getAllCommentInfo();
    }
    @GetMapping("/chapter/{chapterId}")
    public List<CommentInfo> getCommentInfoByChapterId(@PathVariable Long chapterId) {
        return commentService.getAllCommentInfoByChapterId(chapterId);
    }
}
