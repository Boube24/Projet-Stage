//package com.reclamation.service.impl;
//
//import com.reclamation.service.FileStorageService;
//import org.springframework.stereotype.Service;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.IOException;
//import java.nio.file.Files;
//import java.nio.file.Path;
//import java.nio.file.Paths;
//import java.nio.file.StandardCopyOption;
//import java.util.UUID;
//
//@Service
//public class FileStorageServiceImpl implements FileStorageService {
//
//    private static final String UPLOAD_DIR = "uploads";
//
//    @Override
//    public String storeFile(MultipartFile file) {
//
//        try {
//
//            if (file.isEmpty()) {
//                throw new RuntimeException("Le fichier est vide.");
//            }
//
//            String contentType = file.getContentType();
//
//            String folder;
//
//            if (contentType != null && contentType.startsWith("image")) {
//                folder = "images";
//            } else if (contentType != null && contentType.startsWith("video")) {
//                folder = "videos";
//            } else {
//                throw new RuntimeException("Type de fichier non supporté.");
//            }
//
//            Path uploadPath = Paths.get(UPLOAD_DIR, folder);
//
//            if (!Files.exists(uploadPath)) {
//                Files.createDirectories(uploadPath);
//            }
//
//            String originalFilename = file.getOriginalFilename();
//
//            if (originalFilename == null || originalFilename.isBlank()) {
//                originalFilename = "file";
//            }
//
//            String filename = UUID.randomUUID() + "-" + originalFilename;
//
//            Path destination =
//                    uploadPath.resolve(filename);
//
//            Files.copy(
//                    file.getInputStream(),
//                    destination,
//                    StandardCopyOption.REPLACE_EXISTING
//            );
//
//            return "/" + UPLOAD_DIR + "/" + folder + "/" + filename;
//
//        } catch (IOException e) {
//
//            throw new RuntimeException(
//                    "Erreur lors du stockage du fichier.",
//                    e
//            );
//
//        }
//
//    }
//
//}

package com.reclamation.service.impl;

import com.reclamation.service.FileStorageService;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileStorageServiceImpl implements FileStorageService {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    public String storeFile(MultipartFile file) {
        try {
            if (file.isEmpty()) {
                throw new RuntimeException("Le fichier est vide.");
            }

            String contentType = file.getContentType();
            String folder;

            if (contentType != null && contentType.startsWith("image")) {
                folder = "images";
            } else if (contentType != null && contentType.startsWith("video")) {
                folder = "videos";
            } else {
                throw new RuntimeException("Type de fichier non supporté.");
            }

            Path uploadPath = Paths.get(UPLOAD_DIR, folder);

            System.out.println("Upload path = " + uploadPath.toAbsolutePath());

            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }



            // 🛠️ استخراج امتداد الملف الأصلي بأمان لمنع مشاكل الرموز والمسافات
            String originalFilename = file.getOriginalFilename();
            String extension = ".jpg"; // امتداد افتراضي في حال فشل الاستخراج

            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }

            // 🛠️ توليد اسم معياري نظيف تماماً وخالٍ من المسافات
            String filename = UUID.randomUUID().toString() + extension;

            Path destination = uploadPath.resolve(filename);
            System.out.println("Destination = " + uploadPath.resolve(filename).toAbsolutePath());

            System.out.println("==================================");
            System.out.println("Upload Path: " + uploadPath.toAbsolutePath());
            System.out.println("Destination: " + destination.toAbsolutePath());
            System.out.println("File exists before copy: " + Files.exists(destination));
            System.out.println("==================================");

            Files.copy(
                    file.getInputStream(),
                    destination,
                    StandardCopyOption.REPLACE_EXISTING
            );

            // 🛠️ إرجاع مسار نسبي نظيف بدون سلاش زائد في البداية ليتوافق مع Flutter
            return UPLOAD_DIR + "/" + folder + "/" + filename;

        } catch (IOException e) {
            throw new RuntimeException("Erreur lors du stockage du fichier.", e);
        }
    }
}