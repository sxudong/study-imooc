package com.example.test;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * JaCoCo 是一个免费、开源 Java 代码覆盖率工具。IDEA 集成 JaCoCo 方便查看单元测试用例覆盖率。
 * https://blog.csdn.net/IT_LanTian/article/details/123053719
 * https://blog.csdn.net/xixingzhe2/article/details/120031415
 *
 * 1、单元测试用例
 * 注意：单元测试类（CalcTest）必须和被测类（Calc）在同一个包下（com.learn.test）
 *
 * 2、覆盖率报表
 * 报表相对简单，Class 表示类覆盖率，Method 表示方法覆盖率，Line 表示行覆盖率
 *
 * 3、代码覆盖情况
 * 单元测试用例主只写了 add 方法，所以 add 方法显示绿色，覆盖状态，sub 方法显示红色，未被覆盖。
 *
 * 4、总结
 * 通过上述例子可以看出，通过查看覆盖率，逐步善测试用例，写出的用例至少能保障每个分支都被执行，
 * 相比通过需求写用例更能排查出潜在 bug。
 * 需求 ≠代码，不能仅围绕需求写用例，借助 JaCoCo 覆盖率工具编写用例，更符合实际工作需求，更省心省力。
 *
 * 5、查看 html 页面覆盖情况
 *    mvn clean test
 *    执行完成后，查看 target 文件夹下，target/jacoco-report/index.html 报告
 */
public class CalcTest {
    private static Calc add = new Calc();

    @BeforeEach
    void setUp() {
        System.out.println("setUp");
    }

    @AfterEach
    void tearDown() {
        System.out.println("tearDown");
    }

    @Test
    void add() {
        int sum = add.add(1, 2);
        assertEquals(3, sum);
    }
}