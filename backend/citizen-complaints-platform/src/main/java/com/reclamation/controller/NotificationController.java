package com.reclamation.controller;

import com.reclamation.dto.notification.NotificationResponse;
import com.reclamation.service.NotificationService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    /// GET all notifications of user
    @GetMapping("/user/{userId}")
    public List<NotificationResponse> getUserNotifications(
            @PathVariable Long userId) {

        return notificationService.getUserNotifications(userId);
    }

    /// GET unread notifications
    @GetMapping("/user/{userId}/unread")
    public List<NotificationResponse> getUnread(
            @PathVariable Long userId) {

        return notificationService.getUnread(userId);
    }

    /// MARK as read
    @PutMapping("/{id}/read")
    public void markAsRead(@PathVariable Long id) {
        notificationService.markAsRead(id);
    }
}