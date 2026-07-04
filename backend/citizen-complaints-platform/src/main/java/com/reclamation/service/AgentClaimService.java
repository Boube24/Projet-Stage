package com.reclamation.service;

import com.reclamation.dto.AgentClaimResponse;

import java.util.List;

public interface AgentClaimService {

    List<AgentClaimResponse> getClaimsForAgentService(Long serviceId);
}