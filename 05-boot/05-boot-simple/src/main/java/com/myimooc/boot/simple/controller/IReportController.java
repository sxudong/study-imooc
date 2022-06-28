package com.myimooc.boot.simple.controller;


import net.sf.jasperreports.engine.JREmptyDataSource;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * iReport 入门 DEMO,带你快速入门
 * http://www.javashuo.com/article/p-rrpidbmq-tk.html
 *
 * iReport 5.6.0 安装包下载 & 安装
 * http://t.zoukankan.com/miracle-luna-p-10560294.html
 *
 * 示例教程 https://www.jb51.net/article/226205.htm
 */
@RestController
public class IReportController {
    /**
     * 导入为 PDF
     * http://127.0.0.1:8080//exportPdf
     */
    @RequestMapping(value = "/exportPdf")
    public ResponseEntity<byte[]> exportPdf() throws Exception {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource resource = resolver.getResource("jasper/HelloReport.jasper");
        JasperPrint jasperPrint = JasperFillManager.fillReport(resource.getInputStream(), null, new JREmptyDataSource());
        byte[] body = JasperExportManager.exportReportToPdf(jasperPrint);
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.APPLICATION_PDF);
        header.add("Content-Disposition", "inline;filename=hello.pdf");
        return new ResponseEntity<byte[]>(body, header, HttpStatus.OK);
    }
}
