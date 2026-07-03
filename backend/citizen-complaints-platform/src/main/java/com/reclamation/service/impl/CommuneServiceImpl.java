package com.reclamation.service.impl;

import com.reclamation.dto.commune.CommuneResponse;
import com.reclamation.entity.Commune;
import com.reclamation.repository.CommuneRepository;
import com.reclamation.service.CommuneService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CommuneServiceImpl implements CommuneService {

    private final CommuneRepository communeRepository;

    @Override
    public List<CommuneResponse> getAllCommunes() {

        return communeRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    private CommuneResponse mapToResponse(
            Commune commune
    ) {

        return new CommuneResponse(

                commune.getId(),

                commune.getName(),

                commune.getRegion().getId(),

                commune.getRegion().getName()

        );
    }
}