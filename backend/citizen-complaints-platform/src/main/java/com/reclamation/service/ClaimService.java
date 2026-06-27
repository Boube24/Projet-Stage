package com.reclamation.service;

import com.reclamation.dto.claim.ClaimResponse;
import com.reclamation.dto.claim.CreateClaimRequest;

public interface ClaimService {

    ClaimResponse createClaim(
            CreateClaimRequest request,
            String userEmail
    );
}
