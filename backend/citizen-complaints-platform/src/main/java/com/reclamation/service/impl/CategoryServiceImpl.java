package com.reclamation.service.impl;

import com.reclamation.dto.category.CategoryResponse;
import com.reclamation.entity.Category;
import com.reclamation.repository.CategoryRepository;
import com.reclamation.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl  implements CategoryService{

    private final CategoryRepository categoryRepository;

    @Override
    public List<CategoryResponse> getAllCategories() {

        return categoryRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    /**
     * Convertit une entité Category en DTO CategoryResponse.
     */
    private CategoryResponse mapToResponse(Category category) {

        return new CategoryResponse(
                category.getId(),
                category.getName(),
                category.getDescription(),
                category.getService().getId(),
                category.getService().getName()
        );
    }
}
