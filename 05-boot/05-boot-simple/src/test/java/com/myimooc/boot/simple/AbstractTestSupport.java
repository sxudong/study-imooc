package com.myimooc.boot.simple;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.junit.Before;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

/**
 * 集成测试基类
 *
 * @author zc 2020-03-14
 */
/* https://www.jianshu.com/p/c59263b90986

    RunWith(SpringRunner.class)

    SpringRunner extends SpringJUnit4ClassRunner
    SpringJUnit4ClassRunner 的子类，负责在 Junit run 之前为 Test 准备 Springboot 的 support，
    创建 context，负责在跑 JUnit test 之前把 Springboot 启动起来。

    下面就是 SpringJUnit4ClassRunner 的构造方法，从创建 TestContextManager 开始:
        public SpringJUnit4ClassRunner(Class<?> clazz) throws InitializationError {
            super(clazz);
            if (logger.isDebugEnabled()) {
                logger.debug("SpringJUnit4ClassRunner constructor called with [" + clazz + "]");
            }

            ensureSpringRulesAreNotPresent(clazz);
            this.testContextManager = this.createTestContextManager(clazz);
        }

        protected TestContextManager createTestContextManager(Class<?> clazz) {
            return new TestContextManager(clazz);
        }

     是一个测试启动器，可以加载 Springboot 测试注解。
     在正常情况下测试类是需要 @RunWith 的，作用是告诉 java 你这个类通过用什么运行环境运行，
     例如启动和创建 spring 的应用上下文。否则你需要为此在启动时写一堆的环境配置代码。你在
     IDEA 里去掉 @RunWith 仍然能跑是因为在 IDEA 里识别为一个 JUNIT 的运行环境，相当于
     就是一个自识别的 RUNWITH 环境配置。但在其他IDE里并没有。



     看看 @SpringbootTest 的定义，发现它明确定义了 @BootstrapWith(SpringBootTestContextBootstrapper.class)
     SpringBootTestContextBootstrapper 就是 context 的 bootstrapper。SpringJUnit4ClassRunner 会调用
     SpringBootTestContextBootstrapper # buildTestContext() 方法用来创建 test context

     当你的 test class 中声明了 @ContextConfiguration，那么只有声明的 configuration 会被使用，不然的话会从 test class
     所在的 package 一直往上追述，直到找到定义 @SpringBootConfiguration 的 class，也就是 @SpringBootApplication 标注的
     Springboot 的入口方法 (main) 的类，

     这样 Springboot componet scan 机制和 auto-configuration 机制就得以工作。在 Springboot 应用启动时，所有 scope 内的
     bean 都会被加载，这也就是为什么在 test class 中我们可以 Autowire 我们在应用代码中定义的 bean 的原因。
     在 build test context 的过程中我们还发现了 SpringBootTestContextBootstrapper 为我们在 config 中保存了 Active Profile

     ActiveProfilesUtils.resolveActiveProfiles(testClass) 会获取在 Test Class 中使用 @ActiveProfiles 所指定的 profile。

     @ActiveProfiles
     指定 Springboot Test 需要的 Profile，在 context load 的时候会把保存在 config 中的 profile 直接 set 到 environment 中使其生效。
     可以看到在 SpringBootContextLoader 中，通过调用 setActiveProfiles 使得 active profile 最终 set 到当前 environment中。

     结合文章 "Springboot 读取配置文件原理" 可以知道 active profile 是怎么发挥作用，怎么能 map 到对应的 application-{profile}.properties/yaml 文件的。

 */
@RunWith(SpringRunner.class)
// WebEnvironment.RANDOM_PORT 创建一个 web 应用程序上下文。它将随机起一个端口并监听。
// WebEnvironment.MOCK 使用模拟 servlet 环境创建 WebApplicationContext。
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT, properties = {"spring.profiles.active=dev"}) // 开启 Spring 上下文测试
//@ActiveProfiles("dev")
public abstract class AbstractTestSupport {

    // Spring 的 Mock MVC 框架 模拟 Spring MVC
    protected MockMvc mockMvc;
    @Autowired
    // 用来模拟 Http 请求
    protected TestRestTemplate restTemplate;
    @Autowired
    protected ObjectMapper objectMapper;
    // 注入 WebApplicationContext
    @Autowired
    private WebApplicationContext webApplicationContext;

    @Before
    public void setUp() {
        // webAppContextSetup()
        // 使用 Spring 应用程序上下文来构建 Mock MVC，该上下文里可以包含一个或多个配置好的控制器
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
    }
}
