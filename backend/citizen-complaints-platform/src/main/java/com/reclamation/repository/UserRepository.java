package com.reclamation.repository;

import com.reclamation.entity.app_user;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository
        extends JpaRepository<app_user, Long>{

    boolean existsByEmail(String email);

    Optional<app_user> findByEmail(String email);

}
