package com.reclamation.service.impl;


import com.reclamation.dto.media.MediaResponse;
import com.reclamation.entity.Claim;
import com.reclamation.entity.Media;
import com.reclamation.entity.MediaType;
import com.reclamation.entity.app_user;
import com.reclamation.repository.ClaimRepository;
import com.reclamation.repository.MediaRepository;
import com.reclamation.repository.UserRepository;
import com.reclamation.service.FileStorageService;
import com.reclamation.service.MediaService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MediaServiceImpl implements MediaService {

    private final MediaRepository mediaRepository;

    private final ClaimRepository claimRepository;

    private final UserRepository userRepository;

    private final FileStorageService fileStorageService;

    @Override
    public MediaResponse uploadMedia(
            Long claimId,
            MultipartFile file,
            String userEmail
    ) {

        // 1. Récupérer l'utilisateur connecté
        app_user citizen = userRepository.findByEmail(userEmail)
                .orElseThrow(() ->
                        new RuntimeException("Utilisateur introuvable"));

        // 2. Vérifier que la réclamation appartient au citoyen
        Claim claim = claimRepository.findByIdAndCitizenId(
                claimId,
                citizen.getId()
        ).orElseThrow(() ->
                new RuntimeException("Réclamation introuvable"));

        // 3. Stocker le fichier physiquement
        String filePath = fileStorageService.storeFile(file);

        // 4. Déterminer le type du média
        String contentType = file.getContentType();

        MediaType mediaType;

        if (contentType != null && contentType.startsWith("image")) {
            mediaType = MediaType.IMAGE;
        } else if (contentType != null && contentType.startsWith("video")) {
            mediaType = MediaType.VIDEO;
        } else {
            throw new RuntimeException("Type de fichier non supporté");
        }

        // 5. Créer l'entité Media
        Media media = new Media();
        media.setUrl(filePath);
        media.setType(mediaType);
        media.setUploadedAt(LocalDateTime.now());
        media.setClaim(claim);

        // 6. Sauvegarder en base
        Media savedMedia = mediaRepository.save(media);

        // 7. Retourner la réponse
        return mapToResponse(savedMedia);
    }

    private MediaResponse mapToResponse(Media media) {

        MediaResponse response = new MediaResponse();

        response.setId(media.getId());
        response.setUrl(media.getUrl());
        response.setType(media.getType().name());
        response.setUploadedAt(media.getUploadedAt());

        return response;
    }

    @Override
    public List<MediaResponse> getClaimMedia(
            Long claimId,
            String userEmail
    ) {

        // 1. Récupérer l'utilisateur connecté
        app_user citizen = userRepository.findByEmail(userEmail)
                .orElseThrow(() ->
                        new RuntimeException("Utilisateur introuvable"));

        // 2. Vérifier que la réclamation appartient au citoyen
        Claim claim = claimRepository.findByIdAndCitizenId(
                claimId,
                citizen.getId()
        ).orElseThrow(() ->
                new RuntimeException("Réclamation introuvable"));

        // 3. Récupérer les médias liés à la réclamation
        List<Media> mediaList = mediaRepository
                .findByClaimIdOrderByUploadedAtAsc(claim.getId());

        // 4. Convertir en DTO
        return mediaList.stream()
                .map(this::mapToResponse)
                .toList();
    }
}
