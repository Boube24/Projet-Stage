package com.reclamation.service;

import com.reclamation.dto.media.MediaResponse;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface MediaService {

    MediaResponse uploadMedia(
            Long claimId,
            MultipartFile file,
            String userEmail
    );

    List<MediaResponse> getClaimMedia(
            Long claimId,
            String userEmail
    );

}