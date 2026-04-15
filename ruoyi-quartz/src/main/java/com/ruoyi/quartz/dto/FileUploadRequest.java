package com.ruoyi.quartz.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FileUploadRequest {

    private String type;
    private String imgPath;
    public String getImgPath() {
            return imgPath;
        }public void setImgPath(String imgPath) {
            this.imgPath = imgPath;
        }
}