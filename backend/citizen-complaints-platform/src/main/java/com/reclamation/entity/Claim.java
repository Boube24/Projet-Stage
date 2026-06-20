package com.reclamation.entity;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "claim")
public class Claim {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String reference;

    private String title;

    private String description;

    private Double latitude;

    private Double longitude;

    @Enumerated(EnumType.STRING)
    private ClaimStatus currentStatus;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private app_user citizen;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    @ManyToOne
    @JoinColumn(name = "commune_id")
    private Commune commune;
}
