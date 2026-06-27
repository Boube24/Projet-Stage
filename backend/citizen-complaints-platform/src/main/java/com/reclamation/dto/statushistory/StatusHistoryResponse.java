package com.reclamation.dto.statushistory;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class StatusHistoryResponse {

    private Long id;

    private String oldStatus;

    private String newStatus;

    private String comment;

    private LocalDateTime changedAt;

    private Long changedById;

    private String changedByName;

}