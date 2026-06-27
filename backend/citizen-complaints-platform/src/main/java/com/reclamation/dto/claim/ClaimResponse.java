package com.reclamation.dto.claim;

import com.reclamation.entity.ClaimStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClaimResponse {

    private Long id;

    private String reference;

    private String title;

    private String description;

    private BigDecimal latitude;

    private BigDecimal longitude;

    private ClaimStatus status;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private Long categoryId;

    private String categoryName;

    private Long communeId;

    private String communeName;

    private Long regionId;

    private String regionName;

}
