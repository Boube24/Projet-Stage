package com.reclamation.entity;
import jakarta.persistence.*;
import java.time.LocalDateTime;


@Entity
@Table(name = "status_history")
public class StatusHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String oldStatus;

    private String newStatus;

    private String comment;

    private LocalDateTime changedAt;

    @ManyToOne
    @JoinColumn(name = "claim_id")
    private Claim claim;

    @ManyToOne
    @JoinColumn(name = "changed_by")
    private app_user changedBy;
}

