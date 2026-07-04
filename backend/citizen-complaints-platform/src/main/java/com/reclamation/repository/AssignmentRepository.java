package com.reclamation.repository;

import com.reclamation.entity.Assignment;
import com.reclamation.entity.AssignmentStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AssignmentRepository
        extends JpaRepository<Assignment, Long> {

    /**
     * Affectation active d'une réclamation.
     */
    Optional<Assignment> findByClaimIdAndStatus(
            Long claimId,
            AssignmentStatus status
    );

    /**
     * Toutes les affectations d'un service.
     */
    List<Assignment> findByServiceId(Long serviceId);

    /**
     * Affectations actives d'un service.
     */

    List<Assignment> findByServiceIdAndStatus(
            Long serviceId,
            AssignmentStatus status
    );

}