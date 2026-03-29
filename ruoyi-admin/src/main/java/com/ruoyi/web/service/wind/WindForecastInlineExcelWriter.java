package com.ruoyi.web.service.wind;

import com.ruoyi.common.config.RuoYiConfig;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 将页面编辑的行数据写成 Python predict 所需的两个 xlsx（特征四列风速 + 实测第二列为功率）。
 */
public final class WindForecastInlineExcelWriter {

    public static final String H30 = "30米处风速";
    public static final String H50 = "50米处风速";
    public static final String H70 = "70米处风速";
    public static final String HHUB = "风机轮毂处风速";
    private static final String REAL_COL0 = "序号";
    private static final String REAL_COL1 = "实际功率";

    private static final String[] JSON_KEYS = {"w30", "w50", "w70", "whub", "power"};

    private WindForecastInlineExcelWriter() {
    }

    /**
     * @return [featureXlsx, realXlsx] 绝对路径
     */
    public static Path[] write(long deviceId, List<Map<String, Object>> rows) throws Exception {
        if (rows == null) {
            rows = List.of();
        }
        List<double[]> valid = new ArrayList<>();
        for (Map<String, Object> r : rows) {
            double[] v = parseRow(r);
            if (v != null) {
                valid.add(v);
            }
        }
        if (valid.size() < 35) {
            throw new IllegalArgumentException("有效数据行过少（需至少约 35 行有效数值），请补充风速与功率后再预测");
        }
        Path base = Paths.get(RuoYiConfig.getProfile(), "wind-inline", String.valueOf(deviceId));
        Files.createDirectories(base);
        Path featurePath = base.resolve("feature_inline.xlsx");
        Path realPath = base.resolve("real_inline.xlsx");
        writeFeature(valid, featurePath);
        writeReal(valid, realPath);
        return new Path[]{featurePath.toAbsolutePath(), realPath.toAbsolutePath()};
    }

    private static double[] parseRow(Map<String, Object> r) {
        if (r == null) {
            return null;
        }
        double[] out = new double[5];
        boolean any = false;
        for (int i = 0; i < 5; i++) {
            double x = num(r.get(JSON_KEYS[i]));
            if (Double.isFinite(x)) {
                any = true;
            }
            out[i] = x;
        }
        if (!any) {
            return null;
        }
        for (double x : out) {
            if (!Double.isFinite(x)) {
                return null;
            }
        }
        return out;
    }

    private static double num(Object o) {
        if (o == null) {
            return Double.NaN;
        }
        if (o instanceof Number) {
            return ((Number) o).doubleValue();
        }
        String s = String.valueOf(o).trim();
        if (s.isEmpty()) {
            return Double.NaN;
        }
        try {
            return Double.parseDouble(s);
        } catch (NumberFormatException e) {
            return Double.NaN;
        }
    }

    private static void writeFeature(List<double[]> rows, Path path) throws Exception {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sh = wb.createSheet("data");
            Row h = sh.createRow(0);
            h.createCell(0).setCellValue(H30);
            h.createCell(1).setCellValue(H50);
            h.createCell(2).setCellValue(H70);
            h.createCell(3).setCellValue(HHUB);
            int ri = 1;
            for (double[] v : rows) {
                Row row = sh.createRow(ri++);
                row.createCell(0).setCellValue(v[0]);
                row.createCell(1).setCellValue(v[1]);
                row.createCell(2).setCellValue(v[2]);
                row.createCell(3).setCellValue(v[3]);
            }
            try (OutputStream os = Files.newOutputStream(path)) {
                wb.write(os);
            }
        }
    }

    private static void writeReal(List<double[]> rows, Path path) throws Exception {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sh = wb.createSheet("data");
            Row h = sh.createRow(0);
            h.createCell(0).setCellValue(REAL_COL0);
            h.createCell(1).setCellValue(REAL_COL1);
            int ri = 1;
            for (int i = 0; i < rows.size(); i++) {
                Row row = sh.createRow(ri++);
                row.createCell(0).setCellValue(i + 1);
                row.createCell(1).setCellValue(rows.get(i)[4]);
            }
            try (OutputStream os = Files.newOutputStream(path)) {
                wb.write(os);
            }
        }
    }
}
