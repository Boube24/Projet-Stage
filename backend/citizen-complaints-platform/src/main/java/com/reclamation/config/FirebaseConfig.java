package com.reclamation.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import java.io.InputStream;
import java.io.FileInputStream;

@Configuration
public class FirebaseConfig {

//    @PostConstruct
//    public void init() {
//        try {
//
//            FileInputStream serviceAccount =
//                    new FileInputStream(
//                            "src/main/resources/firebase/reclamation-d588f-firebase-adminsdk-fbsvc-b093eea014.json"
//                    );
//
//            FirebaseOptions options = FirebaseOptions.builder()
//                    .setCredentials(
//                            GoogleCredentials.fromStream(serviceAccount)
//                    )
//                    .build();
//
//            if (FirebaseApp.getApps().isEmpty()) {
//                FirebaseApp.initializeApp(options);
//            }
//
//        } catch (Exception e) {
//            throw new RuntimeException(
//                    "Firebase initialization failed",
//                    e
//            );
//        }
//    }

    @PostConstruct
    public void init() {
        try {
            // Using ClassPathResource allows Spring to find the file inside target/classes at runtime
            String configPath = "firebase/reclamation-d588f-firebase-adminsdk-fbsvc-b093eea014.json";
            InputStream serviceAccount = new ClassPathResource(configPath).getInputStream();

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                System.out.println("Firebase application has been initialized successfully.");
            }
        } catch (Exception e) {
            throw new RuntimeException("Firebase initialization failed", e);
        }
    }
}