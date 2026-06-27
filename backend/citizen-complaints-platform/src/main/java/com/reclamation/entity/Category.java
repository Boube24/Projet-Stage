package com.reclamation.entity;

import jakarta.persistence.*;
import lombok.Data;



@Data
@Entity
@Table(name = "category")
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(length = 255)
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "service_id", nullable = false)
    private Service2 service;
}
