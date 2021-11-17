package com.panda.servlet;

import com.panda.annotation.*;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.net.URL;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class MyDispatcherServlet extends HttpServlet {
    //类名列表
    private List<String> classNames = new ArrayList<String>();

    //ioc容器，Map<类名，类实例>
    private Map<String, Object> ioc = new HashMap<String, Object>();

    private List<Handler> handlerMapping = new ArrayList<Handler>();

    @Override
    public void init(ServletConfig config) throws ServletException {
        System.out.println("init...");

        //1.扫描包，将包内所有对象类名存储到list中
        doScanner("com.panda.web");
        System.out.println("========第一步:扫描文件包==========");
        classNames.forEach(value -> System.out.println("保存类名：" + value));

        //2.IOC实现，单例模式，new出对象，放入Map中
        doInstance();
        System.out.println("========第二步:IOC==========");
        ioc.forEach((key, value) -> System.out.println("IOC名称：" + key + ":" + value));

        //3.DI实现，依赖注入。实现注释MyAutowired的类，进行赋值
        doAutoWired();

        //4.将requestMapping注释的method方法，放入到Arraylist中
        initHandlerMapping();

    }

    private void doScanner(String packageName) {
        //1.获取当前class的文件路径下的com.panda.web下的文件路径，
        URL resource =
                this.getClass().getClassLoader().getResource("/" + packageName.replaceAll("\\.", "/"));
        File classDir = new File(resource.getFile());
        for (File classFile : classDir.listFiles()) {
            if (classFile.isDirectory()) {
                //2.递归，如果遇到文件夹，递归扫描此文件夹下的class
                doScanner(packageName + "." + classFile.getName());
            } else {
                //3.文件，直接获取文件名称，存放到List中，形式为com.panda.web.controller.UserController
                String className = (packageName + "." + classFile.getName()).replace(".class", "");
                classNames.add(className);
            }
        }
    }

    private void doInstance() {
        if (classNames.isEmpty()) {
            return;
        }
        try {
            //循环所有扫描出来的类名，将其实例化，并放入ioc容器中
            for (String className : classNames) {
                //类反射机制，获取clazz
                Class<?> clazz = Class.forName(className);
                //如果有MyController注解，说明为controller类，可初始化
                if (clazz.isAnnotationPresent(MyController.class)) {
                    //ioc的beanId的格式为类名，且首字母小写
                    String beanName = lowerFirstCase(clazz.getSimpleName());
                    ioc.put(beanName, clazz.newInstance());
                    //如果有MyService注解，说明为service类，可初始化
                } else if (clazz.isAnnotationPresent(MyService.class)) {

                    //1.如果自己起了名字，优先使用自己的
                    //2.如果没起名字，使用首字母小写
                    //3.如果自动注入的为接口，使用接口的全称

                    MyService service = clazz.getAnnotation(MyService.class);
                    String beanName = service.value();
                    if ("".equals(beanName)) {
                        beanName = lowerFirstCase(clazz.getSimpleName());
                    }
                    Object instance = clazz.newInstance();
                    ioc.put(beanName, instance);
                    //service注解的时候，如实现接口时，再put一次
                    Class<?>[] interfaces = clazz.getInterfaces();
                    for (Class<?> i : interfaces) {
                        ioc.put(i.getName(), instance);
                    }
                } else {
                    //如无注解，无需初始化。
                    continue;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void doAutoWired() {
        if (ioc.isEmpty()) {
            return;
        }
        //注入就是对类中定义的一些属性，进行赋值
        //不管是公有的还是私有的，都需要赋值
        for (Map.Entry<String, Object> entry : ioc.entrySet()) {
            //getDeclaredFields获取类中，所有的属性值
            Field[] fields = entry.getValue().getClass().getDeclaredFields();
            for (Field field : fields) {
                //如果属性上，无注解，直接循环下一次。如有MyAutowired才进行操作
                if (!field.isAnnotationPresent(MyAutowired.class)) {
                    continue;
                }
                MyAutowired autowired = field.getAnnotation(MyAutowired.class);
                String beanName = autowired.value();
                if ("".equals(beanName)) {
                    //如果beanName是空，使用默认接口注入
                    beanName = field.getType().getName();
                }
                //开始赋值，setAccessible - 强制访问
                field.setAccessible(true);

                //通过反射机制，强制赋值。将ioc初始化实例后的对象赋值到MyAutowired属性值上
                try {
                    field.set(entry.getValue(), ioc.get(beanName));
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                    continue;
                }
            }
        }
    }

    private void initHandlerMapping() {
        if (ioc.isEmpty()) {
            return;
        }
        for (Map.Entry<String, Object> entry : ioc.entrySet()) {
            Class<?> clazz = entry.getValue().getClass();
            //如果类的注解不是MyController，则继续循环，此方法只处理controller层
            if (!clazz.isAnnotationPresent(MyController.class)) {
                continue;
            }
            String baseUrl = "";
            //如果类注解有MyRequestMapping，说明定义了根路径，将此路径存储起来
            if (clazz.isAnnotationPresent(MyRequestMapping.class)) {
                MyRequestMapping requestMapping = clazz.getAnnotation(MyRequestMapping.class);
                baseUrl = requestMapping.value();
            }
            //获取controller类的所有方法，并变量
            Method[] methods = clazz.getMethods();
            for (Method method : methods) {
                //如方法无注解，则继续循环，目的获取到所有MyRequestMapping注解的方法
                if (!method.isAnnotationPresent(MyRequestMapping.class)) {
                    continue;
                }
                //获取MyRequestMapping注解的路径，并与根路径进行拼接
                MyRequestMapping requestMapping = method.getAnnotation(MyRequestMapping.class);
                String url = (baseUrl + requestMapping.value()).replaceAll("/+", "/");
                Pattern pattern = Pattern.compile(url);
                //url和method的方法，封装到handler类中
                handlerMapping.add(new Handler(pattern, entry.getValue(), method));
                System.out.println("mapped:" + url + "=>" + method);
            }
        }
    }


    private String lowerFirstCase(String str) {
        char[] chars = str.toCharArray();
        chars[0] += 32;
        return String.valueOf(chars);
    }


    //内部类
    private class Handler {
        protected Object controller;//保存controller的实例对象
        protected Method method;//保存controller类的method方法
        protected Pattern pattern;//url正则表达是
        protected Map<String, Integer> paramIndexMapping;//param注解的map存储

        protected Handler(Pattern pattern, Object controller, Method method) {
            this.pattern = pattern;
            this.controller = controller;
            this.method = method;
            paramIndexMapping = new HashMap<String, Integer>();
            putParamIndexMapping(method);
        }

        private void putParamIndexMapping(Method method) {
            Annotation[][] pa = method.getParameterAnnotations();
            for (int i = 0; i < pa.length; i++) {
                for (Annotation a : pa[i]) {
                    if (a instanceof MyRequestParam) {
                        String paramName = ((MyRequestParam) a).value();
                        if (!"".equals(paramName)) {
                            paramIndexMapping.put(paramName, i);
                        }
                    }
                }
            }
            Class<?>[] paramTypes = method.getParameterTypes();
            for (int i = 0; i < paramTypes.length; i++) {
                Class<?> type = paramTypes[i];
                if (type == HttpServletRequest.class || type == HttpServletResponse.class) {
                    paramIndexMapping.put(type.getName(), i);
                }
            }
        }
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        this.doPost(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doDispatcher(req, res);
    }

    public void doDispatcher(HttpServletRequest req, HttpServletResponse res) {
        try {
            //获取request中的url访问路径和参数，从ArrayList的handlerMapping中查找。找到后，执行method方法
            Handler handler = getHandler(req);
            if (handler == null) {
                res.getWriter().write("404 not found.");
                return;
            }
            Class<?>[] paramTypes = handler.method.getParameterTypes();
            Object[] paramValues = new Object[paramTypes.length];
            //获取访问链接中的params，并对其循环
            Map<String, String[]> params = req.getParameterMap();
            for (Map.Entry<String, String[]> param : params.entrySet()) {
                String value = Arrays.toString(param.getValue()).replaceAll("\\[|\\]", "");
                if (!handler.paramIndexMapping.containsKey(param.getKey())) {
                    continue;
                }
                int index = handler.paramIndexMapping.get(param.getKey());
                paramValues[index] = convert(paramTypes[index], value);
            }
            int reqIndex = handler.paramIndexMapping.get(HttpServletRequest.class.getName());
            paramValues[reqIndex] = req;
            int resIndex = handler.paramIndexMapping.get(HttpServletResponse.class.getName());
            paramValues[resIndex] = res;
            //method方法执行
            handler.method.invoke(handler.controller, paramValues);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //通过request的url链接，寻找handler对象中是否有对应的method
    private Handler getHandler(HttpServletRequest req) {
        if (handlerMapping.isEmpty()) {
            return null;
        }
        String url = req.getRequestURI();
        String contextPath = req.getContextPath();
        url = url.replace(contextPath, "").replaceAll("/+", "/");
        for (Handler handler : handlerMapping) {
            Matcher matcher = handler.pattern.matcher(url);
            if (!matcher.matches()) {
                continue;
            }
            //url有对应的method，返回handler
            return handler;
        }
        //url无对应的method，返回null
        return null;
    }

    private Object convert(Class<?> type, String value) {
        if (Integer.class == type) {
            return Integer.valueOf(value);
        }
        return value;
    }

}
