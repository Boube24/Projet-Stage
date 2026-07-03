package com.reclamation.controller;

import com.reclamation.dto.commune.CommuneResponse;
import com.reclamation.service.CommuneService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/communes")
@RequiredArgsConstructor
public class CommuneController {

    private final CommuneService communeService;

    @GetMapping
    public List<CommuneResponse> getAllCommunes() {

        return communeService.getAllCommunes();

    }

}