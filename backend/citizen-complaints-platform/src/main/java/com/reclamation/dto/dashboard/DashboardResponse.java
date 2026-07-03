package com.reclamation.dto.dashboard;

import com.reclamation.dto.claim.ClaimSummaryResponse;
import lombok.Data;

import java.util.List;

@Data
public class DashboardResponse {

    private long totalClaims;

    private long newClaims;

    private long inProgressClaims;

    private long resolvedClaims;

    private long rejectedClaims;

    private long unreadNotifications;

    private List<ClaimSummaryResponse> recentClaims;

}