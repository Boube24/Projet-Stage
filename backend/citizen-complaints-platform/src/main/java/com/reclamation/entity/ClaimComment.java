package com.reclamation.entity;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.Data;

@Data

@Entity
@Table(name = "claim_comment")
public class ClaimComment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String content;

    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "claim_id")
    private Claim claim;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private app_user user;
}
