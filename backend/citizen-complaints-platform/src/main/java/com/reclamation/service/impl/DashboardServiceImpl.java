package com.reclamation.service.impl;

import com.reclamation.dto.claim.ClaimSummaryResponse;
import com.reclamation.dto.dashboard.DashboardResponse;
import com.reclamation.entity.Claim;
import com.reclamation.entity.ClaimStatus;
import com.reclamation.entity.app_user;
import com.reclamation.repository.ClaimRepository;
import com.reclamation.repository.NotificationRepository;
import com.reclamation.repository.UserRepository;
import com.reclamation.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DashboardServiceImpl implements DashboardService {

    private final UserRepository userRepository;

    private final ClaimRepository claimRepository;

    private final NotificationRepository notificationRepository;

    @Override
    public DashboardResponse getDashboard(
            String userEmail) {

        app_user citizen = userRepository
                .findByEmail(userEmail)
                .orElseThrow(() ->
                        new RuntimeException("Utilisateur introuvable"));

        DashboardResponse response =
                new DashboardResponse();

        response.setTotalClaims(
                claimRepository.countByCitizenId(
                        citizen.getId()));

        response.setNewClaims(
                claimRepository.countByCitizenIdAndCurrentStatus(
                        citizen.getId(),
                        ClaimStatus.NEW));

        response.setInProgressClaims(
                claimRepository.countByCitizenIdAndCurrentStatus(
                        citizen.getId(),
                        ClaimStatus.IN_PROGRESS));

        response.setResolvedClaims(
                claimRepository.countByCitizenIdAndCurrentStatus(
                        citizen.getId(),
                        ClaimStatus.RESOLVED));

        response.setRejectedClaims(
                claimRepository.countByCitizenIdAndCurrentStatus(
                        citizen.getId(),
                        ClaimStatus.REJECTED));

        response.setUnreadNotifications(
                notificationRepository.countByUserIdAndIsReadFalse(
                        citizen.getId()));

        List<ClaimSummaryResponse> recentClaims =
                claimRepository
                        .findTop5ByCitizenIdOrderByCreatedAtDesc(
                                citizen.getId())
                        .stream()
                        .map(this::mapToSummaryResponse)
                        .toList();

        response.setRecentClaims(
                recentClaims);

        return response;
    }

    private ClaimSummaryResponse mapToSummaryResponse(
            Claim claim) {

        ClaimSummaryResponse response =
                new ClaimSummaryResponse();

        response.setId(claim.getId());

        response.setReference(
                claim.getReference());

        response.setTitle(
                claim.getTitle());

        response.setCurrentStatus(
                claim.getCurrentStatus().name());

        response.setCreatedAt(
                claim.getCreatedAt());

        response.setCategoryName(
                claim.getCategory().getName());

        response.setCommuneName(
                claim.getCommune().getName());

        return response;
    }

}