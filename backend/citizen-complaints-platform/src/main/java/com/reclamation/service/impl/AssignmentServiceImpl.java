package com.reclamation.service.impl;

import com.reclamation.entity.*;
import com.reclamation.repository.AssignmentRepository;
import com.reclamation.service.AssignmentService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class AssignmentServiceImpl implements AssignmentService {

    private final AssignmentRepository assignmentRepository;

    public AssignmentServiceImpl(AssignmentRepository assignmentRepository) {
        this.assignmentRepository = assignmentRepository;
    }

    @Override
    public void assignClaimAutomatically(Claim claim) {

        // 1. Récupérer la catégorie
        Category category = claim.getCategory();

        // 2. Récupérer le service associé
        Service2 service = category.getService();

        // 3. Créer l'affectation
        Assignment assignment = new Assignment();

        assignment.setClaim(claim);
        assignment.setService(service);

        assignment.setAssignedAt(LocalDateTime.now());

        assignment.setStatus(AssignmentStatus.ACTIVE);

        // SYSTEM (affectation automatique)
        assignment.setAssignedBy(null);

        assignment.setReason("AUTO ASSIGNMENT");

        // 4. Sauvegarder
        assignmentRepository.save(assignment);
    }
}