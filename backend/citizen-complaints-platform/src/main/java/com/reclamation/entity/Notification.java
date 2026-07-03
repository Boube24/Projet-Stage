package com.reclamation.entity;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.Data;

@Data
@Entity
@Table(name = "notification")
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    private String message;

    private Boolean isRead;

    private LocalDateTime sentAt;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private app_user user;

    @Enumerated(EnumType.STRING)
    private NotificationType type;

    @ManyToOne
    @JoinColumn(name = "claim_id")
    private Claim claim;
}
