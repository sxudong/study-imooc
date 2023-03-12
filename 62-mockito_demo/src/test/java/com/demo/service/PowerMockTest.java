package com.demo.service;

import com.demo.dao.JdbcQueryManager;
import com.demo.model.PageParam;
import com.demo.model.User;
import com.demo.model.UserDTO;
import com.google.common.collect.Lists;
import junit.framework.TestCase;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.*;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.reflect.Whitebox;

import java.lang.reflect.Method;
import java.util.Optional;
import java.util.function.Function;

@RunWith(PowerMockRunner.class)
@PrepareForTest({User.class, UserServiceImpl.class}) // Static.class 是包含 static methods 的类
public class PowerMockTest {
    @InjectMocks
    private UserServiceImpl userServiceImpl;
    @Mock
    private JdbcQueryManager jdbcQueryManager; // 模拟 UserServiceImpl 中的属性 jdbcQueryManager

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        // 可使用 PowerMockito.spy（class）模拟特定方法: 包括私有方法和静态方法
        // mock User 类的静态方法
        PowerMockito.mockStatic(User.class);
    }

    @After
    public void clearMocks() {
        // 避免大量内存泄漏  2.25.0新增
        Mockito.framework().clearInlineMocks();
    }

    /**
     * Mockito测试，实现类逻辑的测试是重点之一
     */
    @Test
    public void testMockito() {
        long id = 9527;
        User user = new User();
        user.setId(id);

        // 测试 userServiceImpl.findById() 方法中逻辑实现有没问题。
        // 模拟设置 jdbcQueryManager#queryForObject(Object var1, Class<E> var2) 将返回一个 user。
        Mockito.when(jdbcQueryManager.queryForObject(user, User.class)).thenReturn(Optional.of(user));
        // 测试返回结果
        TestCase.assertEquals(user, userServiceImpl.findById(id));
    }

    /**
     * mock 静态方法1 （使用 PowerMockito.mockStatic(class) mock 静态方法）
     */
    @Test
    public void testMockStaticMethod1() {
        User user = new User();
        user.setName("白玉京");
        UserDTO dto = new UserDTO();
        dto.setName("白玉京");

        // PowerMock 2.0.7 对下面方法的支持 也就到 Mockito 2.26.X 版本为止
        // 模拟设置 User.convert(User var) 返回一个 dto
        Mockito.when(User.convert(user)).thenReturn(dto);
        // 测试返回结果
        TestCase.assertEquals(dto, User.convert(user));
    }

    /**
     * mock 静态方法2
     * 使用 PowerMockito.spy（class）mock 静态方法
     */
    @Test
    public void testMockStaticMethod2() throws Exception {
        String str = "白玉京";
        PowerMockito.spy(UserServiceImpl.class);

        // 模拟 userServiceImpl#staticMethod(String str) 返回 "35174"
        PowerMockito.when(userServiceImpl, "staticMethod", str).thenReturn("35174");
        // 测试 userServiceImpl.testStaticMethodMethod(String str) 方法
        TestCase.assertEquals("35174", userServiceImpl.testStaticMethodMethod(str));
    }

    /**
     * 函数类型参数匹配。 精确匹配我没找到该怎么匹配
     */
//    @Test
//    public void testFunctionTypeParameterMatching1() {
//        User user = new User();
//        user.setId(9527L);
//
//        // 模拟设置 jdbcQueryManager#queryForList(Object var1, Class<E> var2, Function<E, R> var3) 返回一个 List<UserDTO>
//        Mockito.when(jdbcQueryManager.queryForList(user, User.class, User::convert)).thenReturn(Lists.newArrayList(new UserDTO()));
//        // 测试返回结果
//        TestCase.assertEquals(Lists.newArrayList(new UserDTO()), userServiceImpl.findByUser(user));
//    }

    /**
     * 函数类型参数匹配。 类型匹配
     */
    @Test
    public void testFunctionTypeParameterMatching2() {
        User user = new User();
        user.setId(9527L);

        // 模拟设置 jdbcQueryManager#queryForList(Object var1, Class<E> var2, Function<E, R> var3) 返回一个 List<UserDTO>
        Mockito.when(jdbcQueryManager.queryForList(Mockito.eq(user), Mockito.eq(User.class), Mockito.any(Function.class)))
                .thenReturn(Lists.newArrayList(new UserDTO()));
        // 测试返回结果
        TestCase.assertEquals(Lists.newArrayList(new UserDTO()), userServiceImpl.findByUser(user));
    }

    /**
     * 引用类型参数，未重写 equals 方法, 解决方法
     */
    @Test
    public void testReferenceTypeParameter() {
        long pageNo = 1;
        long pageSize = 20;
        String name = "白玉京";
        User user = new User();
        user.setName(name);

        PageParam pageParam = PageParam.create(pageNo, pageSize);
        // PageParam 未重写 equals 方法,参数匹配通不过
//        Mockito.when(jdbcQueryManager.queryForPageList(user, User.class, pageParam)).thenReturn(Lists.newArrayList(user));

        // 解决方法:
        // 1.重写 equals 方法；
        // 2.模糊匹配；
        // 3.自定义匹配。
        ArgumentMatcher<PageParam> argPage =
                (page) -> page.getPageNo() == pageParam.getPageNo() && page.getPageSize() == pageParam.getPageSize();

        // 模拟设置 jdbcQueryManager#queryForPageList(Object var1, Class<E> var2, PageParam var3) 返回一个 List<E> user
        Mockito.when(jdbcQueryManager.queryForPageList(Mockito.eq(user), Mockito.eq(User.class), Mockito.argThat(argPage)))
                .thenReturn(Lists.newArrayList(user));

        // 测试返回结果
        TestCase.assertEquals(Lists.newArrayList(user), userServiceImpl.findByName(pageNo, pageSize, name));
    }

    /**
     * mock 私有方法
     * 使用 PowerMockito.spy（object）mock 私有方法
     */
    @Test
    public void testMockPrivateMethod() throws Exception {
        String str = "白玉京";
        // 模拟代理 UserServiceImpl
        UserServiceImpl spyObj = PowerMockito.spy(userServiceImpl);

        // 模拟 UserServiceImpl#privateMethod(String str) 返回 "35174"
        PowerMockito.when(spyObj, "privateMethod", str).thenReturn("35174");
        // 测试返回结果
        TestCase.assertEquals("35174", spyObj.testPrivateMethod(str));
    }

    /**
     * 调用私有方法
     * 使用 PowerMockito.method（...）通过反射调用私有方法
     */
    @Test
    public void testCallPrivateMethod() throws Exception {
        String str = "白玉京";
        String result = "I am private method. " + str;

        Method method = PowerMockito.method(UserServiceImpl.class, "privateMethod", String.class);
        // 测试反射调用 UserServiceImpl#privateMethod()方法
        TestCase.assertEquals(result, method.invoke(userServiceImpl, str));
    }

    /**
     * Whitebox 反射调用
     * @throws Exception
     */
    @Test
    public void testPrivateMethod() throws Exception {
        Integer ret = Whitebox.invokeMethod(userServiceImpl, "pleaseTest", 10, 2);
        System.out.println(ret);
        Assert.assertEquals(22, (int) ret);
    }
}






