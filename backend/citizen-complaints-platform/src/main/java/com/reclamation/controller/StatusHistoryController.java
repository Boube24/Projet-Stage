package com.reclamation.controller;

import com.reclamation.dto.statushistory.StatusHistoryResponse;
import com.reclamation.service.StatusHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/claims")
@RequiredArgsConstructor
public class StatusHistoryController {

    private final StatusHistoryService statusHistoryService;

    @GetMapping("/{claimId}/history")
    public List<StatusHistoryResponse> getHistory(
            @PathVariable Long claimId
    ) {

        return statusHistoryService.getClaimHistory(claimId);

    }

}