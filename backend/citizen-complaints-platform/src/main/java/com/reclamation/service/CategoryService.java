package com.reclamation.service;

import com.reclamation.dto.category.CategoryResponse;

import java.util.List;

public interface CategoryService {
    List<CategoryResponse> getAllCategories();
}
