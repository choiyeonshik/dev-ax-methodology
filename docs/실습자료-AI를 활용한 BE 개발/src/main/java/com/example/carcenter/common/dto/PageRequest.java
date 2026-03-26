package com.example.carcenter.common.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.Min;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageRequest {
    
    @Min(value = 0, message = "페이지 번호는 0 이상이어야 합니다.")
    @Builder.Default
    private int page = 0;
    
    @Min(value = 1, message = "페이지 크기는 1 이상이어야 합니다.")
    @Builder.Default
    private int size = 20;
    
    private String sort;
    @Builder.Default
    private String direction = "ASC";
    
    public int getOffset() {
        return page * size;
    }
    
    public int getLimit() {
        return size;
    }
}
