package com.reclamation.dto.claim;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ClaimSummaryResponse {

    private Long id;

    private String reference;

    private String title;

    private String currentStatus;

    private LocalDateTime createdAt;

    private String categoryName;

    private String communeName;

}