package com.reclamation.dto;

import java.time.LocalDateTime;

public class AgentClaimResponse {

    public Long claimId;
    public String reference;
    public String title;
    public String description;

    public String category;
    public String service;

    public String status; // AssignmentStatus

    public LocalDateTime assignedAt;
}