package com.reclamation;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.reclamation")
//@EnableJpaRepositories(basePackages = "com.reclamation.repository")
public class CitizenComplaintsPlatformApplication {

	public static void main(String[] args) {
		SpringApplication.run(CitizenComplaintsPlatformApplication.class, args);
	}
}
