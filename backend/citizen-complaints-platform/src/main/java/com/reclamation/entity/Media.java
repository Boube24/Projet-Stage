package com.reclamation.entity;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Data
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
    @JsonIgnore
    private Claim claim;
}
