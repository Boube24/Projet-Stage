package com.reclamation.service.impl;

import com.reclamation.service.ReferenceGeneratorService;
import com.reclamation.repository.ClaimRepository;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

import java.time.Year;

@Service
@RequiredArgsConstructor
public class ReferenceGeneratorServiceImpl
        implements ReferenceGeneratorService {

    private final ClaimRepository claimRepository;

    @Override
    public String generateClaimReference() {

        Long number = claimRepository.getNextReferenceNumber();

        return String.format(
                "REC-%d-%06d",
                Year.now().getValue(),
                number
        );

    }

}