package com.reclamation.dto.category;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CategoryResponse {

    private Long id;

    private String name;

    private String description;

    private Long serviceId;

    private String serviceName;
}
