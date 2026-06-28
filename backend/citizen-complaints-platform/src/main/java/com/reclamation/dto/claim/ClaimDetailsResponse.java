package com.reclamation.dto.claim;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class ClaimDetailsResponse {

    private Long id;

    private String reference;

    private String title;

    private String description;

    private String currentStatus;

    private BigDecimal latitude;

    private BigDecimal longitude;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private String categoryName;

    private String communeName;

}