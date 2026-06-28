package com.reclamation.repository;

import com.reclamation.entity.Claim;
import com.reclamation.entity.ClaimStatus;
import com.reclamation.entity.app_user;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.Optional;

@Repository
public interface ClaimRepository extends JpaRepository<Claim, Long> {

    /**
     * Retourne toutes les réclamations d'un citoyen.
     */
    List<Claim> findByCitizen(app_user citizen);


    List<Claim> findByCitizenIdOrderByCreatedAtDesc(Long citizenId);
    /**
     * Retourne toutes les réclamations selon leur statut.
     */
    List<Claim> findByCurrentStatus(ClaimStatus status);

    /**
     * Vérifie si une référence existe déjà.
     */
    boolean existsByReference(String reference);

    @Query(value = "SELECT nextval('claim_reference_seq')", nativeQuery = true)
    Long getNextReferenceNumber();

    Optional<Claim> findByIdAndCitizenId(Long id, Long citizenId);

}
