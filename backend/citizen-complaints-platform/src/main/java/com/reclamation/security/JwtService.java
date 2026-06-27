package com.reclamation.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Date;

@Service
public class JwtService {

    private static final String SECRET =
            "mySecretKeymySecretKeymySecretKey123456";

    private Key getSigningKey() {
        return Keys.hmacShaKeyFor(
                SECRET.getBytes()
        );
    }

    public String generateToken(
            String email) {

        return Jwts.builder()
                .setSubject(email)
                .setIssuedAt(
                        new Date())
                .setExpiration(
                        new Date(
                                System.currentTimeMillis()
                                        + 86400000))
                .signWith(
                        getSigningKey(),
                        SignatureAlgorithm.HS256)
                .compact();
    }

    public String extractEmail(
            String token) {

        return Jwts.parser()
                .verifyWith((javax.crypto.SecretKey) getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .getSubject();
    }

    public boolean isTokenValid(
            String token) {

        try {

            Jwts.parser()
                    .verifyWith((javax.crypto.SecretKey) getSigningKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();

            return true;

        } catch (Exception e) {

            return false;
        }
    }

    public boolean isTokenValid(
            String token,
            String email) {

        return extractEmail(token)
                .equals(email);
    }
}
