package com.reclamation.service;

import com.reclamation.dto.statushistory.StatusHistoryResponse;
import com.reclamation.entity.Claim;
import com.reclamation.entity.ClaimStatus;
import com.reclamation.entity.app_user;

import java.util.List;

public interface StatusHistoryService {

    void saveStatusHistory(
            Claim claim,
            ClaimStatus oldStatus,
            ClaimStatus newStatus,
            String comment,
            app_user changedBy
    );

    List<StatusHistoryResponse> getClaimHistory(Long claimId);

}