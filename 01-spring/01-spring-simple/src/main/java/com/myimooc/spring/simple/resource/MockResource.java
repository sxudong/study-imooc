package com.myimooc.spring.simple.resource;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.core.io.Resource;

import java.io.IOException;

/**
 * 模拟加载资源
 *
 * 视频：3-5 Spring Bean装配之Resource
 * 测试单元：ResourceTest.java
 *
 * 针对于资源文件的统一接口Resources
 * - UrlResource: URL对应的资源，根据一个URL地址即可构建- ClassPathResource :获取类路径下的资源文件
 * - FileSystemResource: 获取文件系统里面的资源
 * - ServletContextResource: ServletContext封装的资源，用于访问ServletContext环境下的资源
 * - InputStreamResource: 针对于输入流封装的资源- ByteArrayResource:针对于字节数组封装的资源
 *
 * 所有应用上下文都实现了 ResourceLoader接口，因此所有应用上下文都可以用来获取 Resource 实例。
 * ResourceLoader接口只有一个方法getResource()。
 *
 *   Resource template = ctx.getResource("some/resource/path/myTemplate.txt");
 *   Resource template = ctx.getResource("classpath:some/resource/path/myTemplate.txt");
 *   Resource template = ctx.getResource("file:/some/resource/path/myTemplate.txt");
 */
public class MockResource implements ApplicationContextAware {

    private ApplicationContext applicationContext;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }

    void resource() throws IOException {
        Resource resource = applicationContext.getResource("config.txt");
        System.out.println(resource.getFilename());
        System.out.println(resource.contentLength());
    }

}
