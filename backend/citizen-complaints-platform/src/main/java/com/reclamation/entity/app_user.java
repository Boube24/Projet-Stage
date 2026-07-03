package com.reclamation.entity;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.Data;

@Data
@Entity
@Table(name = "app_user")
public class app_user {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String firstName;

    private String lastName;

    @Column(unique = true)
    private String email;

    private String phone;

    private String password;

    private Boolean enabled = true;

    private LocalDateTime createdAt;

    @Column(length = 512)
    private String fcmtoken;

    @PrePersist
    public void prePersist() {
        createdAt = LocalDateTime.now();
    }

    @ManyToOne
    @JoinColumn(name = "role_id")
    @JsonIgnore
    private role role;

    @ManyToOne
    @JoinColumn(name = "service_id")
    @JsonIgnore
    private Service2 service;
}
