package com.reclamation.entity;
import jakarta.persistence.*;


@Entity
@Table(name = "service")
public class Service2 {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String description;
}
