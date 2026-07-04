package com.reclamation.controller;

import com.reclamation.dto.AgentClaimResponse;
import com.reclamation.service.AgentClaimService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/agent/claims")
public class AgentClaimController {

    private final AgentClaimService agentClaimService;

    public AgentClaimController(AgentClaimService agentClaimService) {
        this.agentClaimService = agentClaimService;
    }

    @GetMapping("/{serviceId}")
    public List<AgentClaimResponse> getClaims(@PathVariable Long serviceId) {
        return agentClaimService.getClaimsForAgentService(serviceId);
    }
}