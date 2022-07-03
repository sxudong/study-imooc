package com.myimooc.boot.simple.controller;

import com.myimooc.boot.simple.model.entity.Sales;
import com.myimooc.boot.simple.model.entity.Saless;
import com.myimooc.boot.simple.model.entity.User;
import com.myimooc.boot.simple.repository.SalesRepository;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * iReport 入门 DEMO,带你快速入门
 * http://www.javashuo.com/article/p-rrpidbmq-tk.html
 * <p>
 * iReport 5.6.0 安装包下载 & 安装
 * http://t.zoukankan.com/miracle-luna-p-10560294.html
 * <p>
 * 示例教程 https://www.jb51.net/article/226205.htm
 *
 * 字体：宋体
 * 列头的高度设置为 20：
 * 	  <columnHeader>
 * 		 <band height="20" splitType="Stretch">
 * 列的高度设置为 20：
 *    <detail>
 *       <band height="20" splitType="Stretch">
 *
 *         <!--导入iReport的包 -->
 *         <dependency>
 *             <groupId>net.sf.jasperreports</groupId>
 *             <artifactId>jasperreports</artifactId>
 *             <version>6.0.0</version>
 *         </dependency>
 *         <dependency>
 *             <groupId>org.codehaus.groovy</groupId>
 *             <artifactId>groovy-all</artifactId>
 *             <version>2.4.11</version>
 *         </dependency>
 *         <!-- 解决中文字体显示问题 -->
 *         <dependency>
 *             <groupId>cn.lesper</groupId>
 *             <artifactId>iTextAsian</artifactId>
 *             <version>3.0</version>
 *         </dependency>
 */
@RestController
public class IReportController {

    @Autowired
    private SalesRepository salesRepository;

    /**
     * 导入为 PDF
     * http://127.0.0.1:8080//exportPdf
     */
    @RequestMapping(value = "/exportPdf")
    public ResponseEntity<byte[]> exportPdf() throws Exception {
        List<Sales> salesList = salesRepository.findAll();
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource resource = resolver.getResource("jasper/HelloReport.jasper");
        JasperPrint jasperPrint = JasperFillManager.fillReport(resource.getInputStream(), null, new JREmptyDataSource());
        byte[] body = JasperExportManager.exportReportToPdf(jasperPrint);
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.APPLICATION_PDF);
        header.add("Content-Disposition", "inline;filename=hello.pdf");
        return new ResponseEntity<byte[]>(body, header, HttpStatus.OK);
    }

    /**
     * http://127.0.0.1:8080/exportPdf2
     * https://blog.csdn.net/weixin_42528266/article/details/103769077
     */
    @RequestMapping(value = "/exportPdf2")
    public void exportPdf2(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //从数据库中获取数据
        List<Sales> salesList = salesRepository.findAll();
        //构造 javaBean 数据源
        JRBeanCollectionDataSource ds = new JRBeanCollectionDataSource(salesList);

        //1.引入jasper文件
        Resource resource = new ClassPathResource("jasper/sales.jasper");
        FileInputStream fis = new FileInputStream(resource.getFile());
        //2.创建JasperPrint,向jasper文件中填充数据
        ServletOutputStream os = response.getOutputStream();
        JasperPrint jasperPrint = JasperFillManager.fillReport(fis, null, ds);

        //3.将JasperPrint已PDF的形式输出
        JasperExportManager.exportReportToPdfStream(jasperPrint, os);
        response.setContentType("application/pdf");
    }

    /**
     * http://127.0.0.1:8080/testJasper02
     * 安装 jar 包到本地仓库
     * 执行 mvn install:install-file -Dfile=D:\softwares\常用工具软件\olap4j-0.9.7.309-JS-3\mylib\olap4j-0.9.7.309-JS-3.jar
     * -DgroupId=org.olap4j -DartifactId=olap4j -Dversion=0.9.7.309-JS-3 -Dpackaging=jar 进行安装
     */
    @GetMapping("/testJasper02")
    public void createPdf2(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        //1.引入jasper文件
        Resource resource = new ClassPathResource("jasper/parametersTest.jasper");
        FileInputStream fis = new FileInputStream(resource.getFile());
        //2.创建JasperPrint,向jasper文件中填充数据
        ServletOutputStream os = response.getOutputStream();
        try {
            /**
             * parameters集合中传递的key需要和设计模板中使用的name一致
             */
            HashMap parameters = new HashMap();
            parameters.put("title", "用户详情");
            parameters.put("username", "李四");
            parameters.put("companyName", "传智播客");
            parameters.put("mobile", "120");
            parameters.put("departmentName", "讲师");
            JasperPrint print = JasperFillManager.fillReport(fis, parameters, new JREmptyDataSource());
            //3.将JasperPrint已PDF的形式输出
            JasperExportManager.exportReportToPdfStream(print, os);
            response.setContentType("application/pdf");
        } catch (JRException e) {
            e.printStackTrace();
        } finally {
            os.flush();
        }
    }

    /**
     * http://127.0.0.1:8080/reportUsers
     */
    @RequestMapping(value = "/reportUsers", method = RequestMethod.GET)
    public void reportChs2(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 报表数据源
        JRDataSource jrDataSource = new JRBeanCollectionDataSource(User.getUserList());

        //1.引入jasper文件
        Resource resource = new ClassPathResource("jasper/user.jasper");
        FileInputStream fis = new FileInputStream(resource.getFile());
        //2.创建JasperPrint,向jasper文件中填充数据
        ServletOutputStream os = response.getOutputStream();

        JasperPrint jasperPrint = JasperFillManager.fillReport(fis, null, jrDataSource);

        //3.将JasperPrint已PDF的形式输出
        JasperExportManager.exportReportToPdfStream(jasperPrint, os);
        response.setContentType("application/pdf");
    }

    /**
     * http://127.0.0.1:8080/reportSales
     */
    @RequestMapping(value = "/reportSales", method = RequestMethod.GET)
    public void reportSales(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 报表数据源
        //JRDataSource jrDataSource = new JRBeanCollectionDataSource(getSalesList());
        JRDataSource jrDataSource = new JRBeanCollectionDataSource(getSalesList());

        //1.引入jasper文件
        Resource resource = new ClassPathResource("jasper/sales.jasper");
        FileInputStream fis = new FileInputStream(resource.getFile());
        //2.创建JasperPrint,向jasper文件中填充数据
        ServletOutputStream os = response.getOutputStream();

        JasperPrint jasperPrint = JasperFillManager.fillReport(fis, null, jrDataSource);

        //3.将JasperPrint已PDF的形式输出
        JasperExportManager.exportReportToPdfStream(jasperPrint, os);
        response.setContentType("application/pdf");
    }

    public List<Saless> getSalesList() throws Exception {
        List<Saless> list = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            Saless sales = new Saless(i, "香港", "张三", 1000, 2000, 3000, 4000);
            list.add(sales);
        }
        return list;
    }

    // 创建数据库 Connection，需在 jrxml 中添加 sql
    public Connection getConnection() throws Exception {
        String url = "jdbc:mysql://127.0.0.1:3306/db3?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai";
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, "root", "root");
        return conn;
    }
}
