package com.reclamation.service;

import com.reclamation.dto.claim.ClaimResponse;
import com.reclamation.dto.claim.CreateClaimRequest;
import com.reclamation.dto.claim.ClaimSummaryResponse;
import java.util.List;
import com.reclamation.dto.claim.ClaimDetailsResponse;

public interface ClaimService {

    ClaimResponse createClaim(
            CreateClaimRequest request,
            String userEmail
    );

    List<ClaimSummaryResponse> getMyClaims(String userEmail);

    ClaimDetailsResponse getClaimDetails(Long claimId, String userEmail);


}
