package com.reclamation.repository;

import com.reclamation.entity.StatusHistory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StatusHistoryRepository
        extends JpaRepository<StatusHistory, Long> {

    List<StatusHistory> findByClaimIdOrderByChangedAtAsc(Long claimId);

}