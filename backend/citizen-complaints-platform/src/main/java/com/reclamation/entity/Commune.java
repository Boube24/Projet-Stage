package com.reclamation.entity;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "commune")
public class Commune {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @ManyToOne
    @JoinColumn(name = "region_id")
    private Region region;
}
