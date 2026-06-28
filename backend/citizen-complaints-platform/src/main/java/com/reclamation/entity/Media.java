package com.reclamation.entity;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "media")
public class Media {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String url;

    @Enumerated(EnumType.STRING)
    private MediaType type;

    private LocalDateTime uploadedAt;

    @ManyToOne
    @JoinColumn(name = "claim_id")
    private Claim claim;
}
