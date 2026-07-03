package com.reclamation.dto.media;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MediaResponse {

    private Long id;

    private String url;

    private String type;

    private LocalDateTime uploadedAt;

}