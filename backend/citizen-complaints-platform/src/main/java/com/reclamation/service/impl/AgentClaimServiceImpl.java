package com.reclamation.service.impl;

import com.reclamation.dto.AgentClaimResponse;
import com.reclamation.entity.Assignment;
import com.reclamation.entity.AssignmentStatus;
import com.reclamation.repository.AssignmentRepository;
import com.reclamation.service.AgentClaimService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AgentClaimServiceImpl implements AgentClaimService {

    private final AssignmentRepository assignmentRepository;

    public AgentClaimServiceImpl(AssignmentRepository assignmentRepository) {
        this.assignmentRepository = assignmentRepository;
    }

    @Override
    public List<AgentClaimResponse> getClaimsForAgentService(Long serviceId) {

        List<Assignment> assignments =
                assignmentRepository.findByServiceIdAndStatus(
                        serviceId,
                        AssignmentStatus.ACTIVE
                );

        return assignments.stream().map(a -> {

            AgentClaimResponse dto = new AgentClaimResponse();

            dto.claimId = a.getClaim().getId();
            dto.reference = a.getClaim().getReference();
            dto.title = a.getClaim().getTitle();
            dto.description = a.getClaim().getDescription();

            dto.category = a.getClaim().getCategory().getName();
            dto.service = a.getService().getName();

            dto.status = a.getStatus().name();
            dto.assignedAt = a.getAssignedAt();

            return dto;

        }).collect(Collectors.toList());
    }
}