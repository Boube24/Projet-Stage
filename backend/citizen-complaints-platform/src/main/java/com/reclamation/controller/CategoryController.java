package com.reclamation.controller;

import com.reclamation.dto.category.CategoryResponse;
import com.reclamation.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping
    public ResponseEntity<List<CategoryResponse>> getAllCategories() {

        List<CategoryResponse> categories =
                categoryService.getAllCategories();

        return ResponseEntity.ok(categories);
    }
}
