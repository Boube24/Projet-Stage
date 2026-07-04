package com.reclamation.service;

import com.reclamation.entity.Claim;

public interface AssignmentService {

    /**
     * Affecte automatiquement une réclamation
     * au service correspondant à sa catégorie.
     */
    void assignClaimAutomatically(Claim claim);

}