package com.reclamation.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.util.List;

@Configuration
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    // إضافة الـ Constructor لحقن ملف الـ JWTAuthenticationFilter بنجاح
    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                // 1. ربط إعدادات الـ CORS التي قمنا بتعريفها في الأسفل
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))

                // 2. تعطيل CSRF (لأن الـ APIs التي تعتمد على JWT تكون stateless عادةً)
                .csrf(csrf -> csrf.disable())

                .sessionManagement(
                        session ->
                                session.sessionCreationPolicy(
                                        SessionCreationPolicy.STATELESS
                                )
                )

                // 3. تحديد الصلاحيات للمسارات
                .authorizeHttpRequests(auth -> auth
                        // السماح للجميع بزيارة مسارات التسجيل وتسجيل الدخول
                        .requestMatchers("/api/auth/register", "/api/auth/login").permitAll()
                        // أي طلب آخر يتطلب تسجيل دخول (Authentication)
                        .anyRequest().authenticated()
                )

                // 4. إضافة فلتر الـ JWT قبل فلتر تسجيل الدخول التقليدي
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        // السماح لجميع النطاقات، الميثودز، والهيدرز بالوصول (مفيد في التطوير)
        // ملاحظة: في البيئة الفعلية (Production)، يفضل تحديد النطاقات بدقة لحماية تطبيقك.
        configuration.setAllowedOriginPatterns(List.of("*"));
        configuration.setAllowedMethods(List.of("*"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }


}