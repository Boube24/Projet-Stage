package com.reclamation.dto.notification;

import com.reclamation.entity.Notification;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NotificationResponse {

    private Long id;

    private String title;

    private String message;

    private Boolean isRead;

    private LocalDateTime sentAt;

    private Long userId;

    private Long claimId;

    private String type;

    public NotificationResponse(Notification notification) {

        this.id = notification.getId();

        this.title = notification.getTitle();

        this.message = notification.getMessage();

        this.isRead = notification.getIsRead();

        this.sentAt = notification.getSentAt();

        this.type = notification.getType().name();

        if (notification.getUser() != null) {
            this.userId = notification.getUser().getId();
        }

        if (notification.getClaim() != null) {
            this.claimId = notification.getClaim().getId();
        }
    }
}