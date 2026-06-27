package com.reclamation.entity;
import jakarta.persistence.*;
import lombok.Data;

@Data

@Entity
@Table(name = "region")
public class Region {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
}
