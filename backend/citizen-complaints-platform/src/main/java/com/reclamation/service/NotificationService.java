package com.reclamation.service;

import com.reclamation.entity.Notification;
import com.reclamation.repository.NotificationRepository;
import org.springframework.stereotype.Service;
import com.reclamation.entity.app_user;
import com.reclamation.entity.Claim;
import com.reclamation.entity.NotificationType;
import com.reclamation.dto.notification.NotificationResponse;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final FirebaseService firebaseService;

    public NotificationService(
            NotificationRepository notificationRepository,
            FirebaseService firebaseService
    ) {
        this.notificationRepository = notificationRepository;
        this.firebaseService = firebaseService;
    }

    public Notification createAndSend(Notification notification) {

        // 1. Save in DB
        notification.setSentAt(java.time.LocalDateTime.now());
        notification.setIsRead(false);

        Notification saved =
                notificationRepository.save(notification);

        // 2. Send push (if user has token)
        String token =
                notification.getUser().getFcmtoken();

        if (token != null && !token.isEmpty()) {

            firebaseService.sendPushNotification(
                    token,
                    notification.getTitle(),
                    notification.getMessage()
            );
        }

        return saved;
    }

    /// ==========================
    /// Get user notifications
    /// ==========================
    public List<NotificationResponse> getUserNotifications(Long userId) {

        return notificationRepository
                .findByUserIdOrderBySentAtDesc(userId)
                .stream()
                .map(NotificationResponse::new)
                .toList();
    }

    /// ==========================
    /// Get unread notifications
    /// ==========================
    public List<NotificationResponse> getUnread(Long userId) {

        return notificationRepository
                .findByUserIdAndIsReadFalse(userId)
                .stream()
                .map(NotificationResponse::new)
                .toList();
    }

    /// ==========================
    /// Mark as read
    /// ==========================
    public void markAsRead(Long notificationId) {
        Notification n = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new RuntimeException("Notification not found"));

        n.setIsRead(true);
        notificationRepository.save(n);
    }


    public Notification createNotification(

            app_user user,

            Claim claim,

            NotificationType type,

            String title,

            String message
    ) {

        Notification notification = new Notification();

        notification.setUser(user);

        notification.setClaim(claim);

        notification.setType(type);

        notification.setTitle(title);

        notification.setMessage(message);

        notification.setIsRead(false);

        notification.setSentAt(LocalDateTime.now());

        Notification saved =
                notificationRepository.save(notification);

        String token = user.getFcmtoken();

        if (token != null && !token.isBlank()) {

            firebaseService.sendPushNotification(
                    token,
                    title,
                    message
            );
        }

        return saved;
    }

}