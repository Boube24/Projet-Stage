package com.reclamation.service.impl;

import com.reclamation.dto.claim.ClaimResponse;
import com.reclamation.dto.claim.CreateClaimRequest;
import com.reclamation.entity.Category;
import com.reclamation.entity.Claim;
import com.reclamation.entity.ClaimStatus;
import com.reclamation.entity.Commune;
import com.reclamation.entity.app_user;
import com.reclamation.repository.CategoryRepository;
import com.reclamation.repository.ClaimRepository;
import com.reclamation.repository.CommuneRepository;
import com.reclamation.repository.UserRepository;
import com.reclamation.service.ClaimService;
import com.reclamation.service.StatusHistoryService;
import com.reclamation.service.ReferenceGeneratorService; // تأكد من استيرادها
import com.reclamation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // ممارسة فضلى للعمليات التي تعدل البيانات
import com.reclamation.dto.claim.ClaimSummaryResponse;
import com.reclamation.dto.claim.ClaimDetailsResponse;

import java.util.List;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ClaimServiceImpl implements ClaimService {

    private final ClaimRepository claimRepository;
    private final ReferenceGeneratorService referenceGeneratorService;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final CommuneRepository communeRepository;
    private final StatusHistoryService statusHistoryService; // <-- إصلاح الخطأ 1: تم إضافة الحقل المفقود هنا

    @Override
    @Transactional // ممارسة فضلى لضمان تراجع التغييرات في حال حدوث خطأ أثناء حفظ التاريخ
    public ClaimResponse createClaim(CreateClaimRequest request, String userEmail) {

        // 1. Récupérer le citoyen connecté
        app_user citizen = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur introuvable"));

        // 2. Vérifier la catégorie
        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new ResourceNotFoundException("Catégorie introuvable")); // <-- إصلاح الخطأ 2: تعديل نص الرسالة

        // 3. Vérifier la commune
        Commune commune = communeRepository.findById(request.getCommuneId())
                .orElseThrow(() -> new ResourceNotFoundException("Commune introuvable")); // يُفضل استخدام نفس الاستثناء المخصص

        // 4. Créer la réclamation
        Claim claim = new Claim();
        claim.setTitle(request.getTitle());
        claim.setDescription(request.getDescription());
        claim.setLatitude(request.getLatitude());
        claim.setLongitude(request.getLongitude());
        claim.setCitizen(citizen);
        claim.setCategory(category);
        claim.setCommune(commune);
        claim.setCurrentStatus(ClaimStatus.NEW);
        claim.setCreatedAt(LocalDateTime.now());
        claim.setUpdatedAt(LocalDateTime.now());

        // Générer la référence
        claim.setReference(referenceGeneratorService.generateClaimReference());

        // Sauvegarde de la réclamation
        Claim savedClaim = claimRepository.save(claim);

        // Sauvegarde de l'historique du statut
        statusHistoryService.saveStatusHistory(
                savedClaim,
                null,
                ClaimStatus.NEW,
                "Réclamation créée.",
                citizen
        );

        // Conversion DTO
        return mapToResponse(savedClaim);
    }

    @Override
    public List<ClaimSummaryResponse> getMyClaims(String userEmail) {

        app_user citizen = userRepository.findByEmail(userEmail)
                .orElseThrow(() ->
                        new RuntimeException("Utilisateur introuvable"));

        return claimRepository
                .findByCitizenIdOrderByCreatedAtDesc(citizen.getId())
                .stream()
                .map(this::mapToSummaryResponse)
                .toList();

    }

    @Override
    public ClaimDetailsResponse getClaimDetails(
            Long claimId,
            String userEmail
    ) {

        app_user citizen = userRepository.findByEmail(userEmail)
                .orElseThrow(() ->
                        new RuntimeException("Utilisateur introuvable"));

        Claim claim = claimRepository
                .findByIdAndCitizenId(claimId, citizen.getId())
                .orElseThrow(() ->
                        new RuntimeException("Réclamation introuvable"));

        return mapToDetailsResponse(claim);

    }


    private ClaimDetailsResponse mapToDetailsResponse(Claim claim) {

        ClaimDetailsResponse response = new ClaimDetailsResponse();

        response.setId(claim.getId());

        response.setReference(claim.getReference());

        response.setTitle(claim.getTitle());

        response.setDescription(claim.getDescription());

        response.setCurrentStatus(
                claim.getCurrentStatus().name()
        );

        response.setLatitude(claim.getLatitude());

        response.setLongitude(claim.getLongitude());

        response.setCreatedAt(claim.getCreatedAt());

        response.setUpdatedAt(claim.getUpdatedAt());

        response.setCategoryName(
                claim.getCategory().getName()
        );

        response.setCommuneName(
                claim.getCommune().getName()
        );

        return response;

    }
    /**
     * Conversion Entity -> DTO
     */
    private ClaimResponse mapToResponse(Claim claim) {
        ClaimResponse response = new ClaimResponse();
        response.setId(claim.getId());
        response.setReference(claim.getReference());
        response.setTitle(claim.getTitle());
        response.setDescription(claim.getDescription());
        response.setLatitude(claim.getLatitude());
        response.setLongitude(claim.getLongitude());
        response.setStatus(claim.getCurrentStatus());
        response.setCreatedAt(claim.getCreatedAt());
        response.setUpdatedAt(claim.getUpdatedAt());

        response.setCategoryId(claim.getCategory().getId());
        response.setCategoryName(claim.getCategory().getName());

        response.setCommuneId(claim.getCommune().getId());
        response.setCommuneName(claim.getCommune().getName());

        // في حال كانت العلاقة مكتملة في الكيانات (Entities):
        if (claim.getCommune().getRegion() != null) {
            response.setRegionId(claim.getCommune().getRegion().getId());
            response.setRegionName(claim.getCommune().getRegion().getName());
        }

        return response;
    }

    private ClaimSummaryResponse mapToSummaryResponse(Claim claim) {

        ClaimSummaryResponse response = new ClaimSummaryResponse();

        response.setId(claim.getId());

        response.setReference(claim.getReference());

        response.setTitle(claim.getTitle());

        response.setCurrentStatus(
                claim.getCurrentStatus().name()
        );

        response.setCreatedAt(claim.getCreatedAt());

        response.setCategoryName(
                claim.getCategory().getName()
        );

        response.setCommuneName(
                claim.getCommune().getName()
        );

        return response;

    }
}