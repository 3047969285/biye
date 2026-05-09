package com.ruoyi.web.service.wind;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.OutputStream;

/**
 * 设备尚无 Excel 时，导出仅含表头的空模板（列名与 Python / {@link WindForecastInlineExcelWriter} 一致）。
 */
public final class WindForecastEmptyExcelTemplate {

    private WindForecastEmptyExcelTemplate() {
    }

    public static void write(String kind, OutputStream out) throws IOException {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sh = wb.createSheet("data");
            Row h = sh.createRow(0);
            if ("feature".equalsIgnoreCase(kind)) {
                h.createCell(0).setCellValue(WindForecastInlineExcelWriter.H30);
                h.createCell(1).setCellValue(WindForecastInlineExcelWriter.H50);
                h.createCell(2).setCellValue(WindForecastInlineExcelWriter.H70);
                h.createCell(3).setCellValue(WindForecastInlineExcelWriter.HHUB);
            } else if ("real".equalsIgnoreCase(kind)) {
                h.createCell(0).setCellValue("序号");
                h.createCell(1).setCellValue("实际功率");
            } else {
                throw new IllegalArgumentException("kind 须为 feature 或 real");
            }
            wb.write(out);
        } catch (IllegalArgumentException e) {
            throw new IOException(e.getMessage(), e);
        } catch (IOException e) {
            throw e;
        } catch (Exception e) {
            throw new IOException(e.getMessage(), e);
        }
    }
}
