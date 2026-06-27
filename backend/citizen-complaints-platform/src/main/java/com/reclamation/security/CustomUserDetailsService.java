package com.reclamation.security;

import com.reclamation.entity.app_user;
import com.reclamation.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService
        implements UserDetailsService{

    private final UserRepository
            userRepository;

    @Override
    public UserDetails loadUserByUsername(
            String email)
            throws UsernameNotFoundException {

        app_user user =
                userRepository.findByEmail(
                                email)
                        .orElseThrow(
                                () ->
                                        new UsernameNotFoundException(
                                                "User not found"));

        return org.springframework.security.core.userdetails.User
                .withUsername(
                        user.getEmail())
                .password(
                        user.getPassword())
                .authorities(
                        user.getRole()
                                .getName())
                .build();
    }
}
