package com.reclamation.controller;

import com.reclamation.dto.media.MediaResponse;
import com.reclamation.service.MediaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/claims")
@RequiredArgsConstructor
public class MediaController {

    private final MediaService mediaService;

    // Upload media
    @PostMapping("/{id}/media")
    public ResponseEntity<MediaResponse> uploadMedia(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file,
            Authentication authentication
    ) {

        String userEmail = authentication.getName();

        MediaResponse response = mediaService.uploadMedia(
                id,
                file,
                userEmail
        );

        return ResponseEntity.ok(response);
    }

    // Get all media of a claim
    @GetMapping("/{id}/media")
    public ResponseEntity<List<MediaResponse>> getClaimMedia(
            @PathVariable Long id,
            Authentication authentication
    ) {

        String userEmail = authentication.getName();

        List<MediaResponse> response = mediaService.getClaimMedia(
                id,
                userEmail
        );

        return ResponseEntity.ok(response);
    }
}