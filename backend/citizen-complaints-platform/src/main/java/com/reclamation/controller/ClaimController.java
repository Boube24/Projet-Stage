package com.reclamation.controller;

import com.reclamation.dto.claim.ClaimResponse;
import com.reclamation.dto.claim.CreateClaimRequest;
import com.reclamation.service.ClaimService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import com.reclamation.dto.claim.ClaimSummaryResponse;
import org.springframework.security.core.Authentication;
import com.reclamation.dto.claim.ClaimDetailsResponse;
import org.springframework.security.core.Authentication;

import java.util.List;

@RestController
@RequestMapping("/api/claims")
@RequiredArgsConstructor
public class ClaimController {

    private final ClaimService claimService;

    @PostMapping
    public ResponseEntity<ClaimResponse> createClaim(
            @Valid @RequestBody CreateClaimRequest request,
            Authentication authentication
    ) {

        String userEmail = authentication.getName();

        ClaimResponse response =
                claimService.createClaim(request, userEmail);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(response);
    }

    @GetMapping("/my")
    public ResponseEntity<List<ClaimSummaryResponse>> getMyClaims(
            Authentication authentication
    ) {

        String userEmail = authentication.getName();

        List<ClaimSummaryResponse> claims =
                claimService.getMyClaims(userEmail);

        return ResponseEntity.ok(claims);

    }

    @GetMapping("/{id}")
    public ResponseEntity<ClaimDetailsResponse> getClaimDetails(
            @PathVariable Long id,
            Authentication authentication
    ) {

        String userEmail = authentication.getName();

        ClaimDetailsResponse response =
                claimService.getClaimDetails(id, userEmail);

        return ResponseEntity.ok(response);

    }


}