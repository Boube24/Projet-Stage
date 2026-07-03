package com.reclamation.service;

import com.reclamation.dto.dashboard.DashboardResponse;

public interface DashboardService {

    DashboardResponse getDashboard(
            String userEmail);

}