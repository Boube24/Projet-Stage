package com.reclamation.entity;

import jakarta.persistence.*;
import java.util.List;
import lombok.Data;
import lombok.ToString;
import lombok.EqualsAndHashCode;


@Data
@ToString(exclude = "categories")
@EqualsAndHashCode(exclude = "categories")
@Entity
@Table(name = "service")
public class Service2 {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(length = 255)
    private String description;


    @OneToMany(mappedBy = "service")
    private List<Category> categories;
}
