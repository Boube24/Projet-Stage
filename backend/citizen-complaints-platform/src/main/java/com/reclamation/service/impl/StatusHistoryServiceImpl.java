package com.reclamation.service.impl;

import com.reclamation.entity.Claim;
import com.reclamation.entity.ClaimStatus;
import com.reclamation.entity.StatusHistory;
import com.reclamation.entity.app_user;
import com.reclamation.repository.StatusHistoryRepository;
import com.reclamation.service.StatusHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.reclamation.dto.statushistory.StatusHistoryResponse;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class StatusHistoryServiceImpl
        implements StatusHistoryService {

    private final StatusHistoryRepository statusHistoryRepository;

    @Override
    public void saveStatusHistory(
            Claim claim,
            ClaimStatus oldStatus,
            ClaimStatus newStatus,
            String comment,
            app_user changedBy
    ) {

        StatusHistory history = new StatusHistory();

        history.setClaim(claim);

        history.setOldStatus(oldStatus);

        history.setNewStatus(newStatus);

        history.setComment(comment);

        history.setChangedAt(LocalDateTime.now());

        history.setChangedBy(changedBy);

        statusHistoryRepository.save(history);

    }

    @Override
    public List<StatusHistoryResponse> getClaimHistory(Long claimId) {

        return statusHistoryRepository
                .findByClaimIdOrderByChangedAtAsc(claimId)
                .stream()
                .map(this::mapToResponse)
                .toList();

    }

    private StatusHistoryResponse mapToResponse(StatusHistory history) {

        StatusHistoryResponse response = new StatusHistoryResponse();

        response.setId(history.getId());

        response.setOldStatus(
                history.getOldStatus() != null
                        ? history.getOldStatus().name()
                        : null
        );

        response.setNewStatus(
                history.getNewStatus().name()
        );

        response.setComment(history.getComment());

        response.setChangedAt(history.getChangedAt());

        if (history.getChangedBy() != null) {

            response.setChangedById(
                    history.getChangedBy().getId()
            );

            response.setChangedByName(
                    history.getChangedBy().getFirstName()
                            + " "
                            + history.getChangedBy().getLastName()
            );

        }

        return response;

    }

}