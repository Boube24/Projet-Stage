package com.reclamation.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "assignment")
public class Assignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Réclamation concernée
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "claim_id")
    private Claim claim;

    /**
     * Service destinataire
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "service_id")
    private Service2 service;

    /**
     * Qui a créé l'affectation
     * (SYSTEM ou ADMIN)
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "assigned_by")
    private app_user assignedBy;

    /**
     * Agent qui prend réellement
     * la réclamation.
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "taken_by")
    private app_user takenBy;

    /**
     * Date d'affectation
     */
    private LocalDateTime assignedAt;

    /**
     * Date de prise en charge
     */
    private LocalDateTime takenAt;

    /**
     * Date de fermeture
     */
    private LocalDateTime closedAt;

    /**
     * Motif
     */
    private String reason;

    /**
     * Etat de l'affectation
     */
    @Enumerated(EnumType.STRING)
    private AssignmentStatus status;

}