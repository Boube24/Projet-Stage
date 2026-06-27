package com.reclamation.citizen_complaints_platform;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = "com.reclamation")
//@EnableJpaRepositories(basePackages = "com.reclamation.repository")
public class CitizenComplaintsPlatformApplication {

	public static void main(String[] args) {
		SpringApplication.run(CitizenComplaintsPlatformApplication.class, args);
	}
}
