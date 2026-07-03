package com.reclamation.dto.commune;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommuneResponse {

    private Long id;

    private String name;

    private Long regionId;

    private String regionName;

}