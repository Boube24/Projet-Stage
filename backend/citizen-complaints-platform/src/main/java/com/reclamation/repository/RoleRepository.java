package com.reclamation.repository;

import com.reclamation.entity.role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoleRepository
                extends JpaRepository<role, Long>  {

    Optional<role> findByName(String name);
}
