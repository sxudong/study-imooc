package com.atguigu.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.FilterType;
import org.springframework.stereotype.Controller;

/*
 父子容器详解
 原文链接：https://blog.csdn.net/likun557/article/details/105608851

 问题1：springmvc 中只使用一个容器是否可以？
   只使用一个容器是可以正常运行的。

 问题2：那么 springmvc 中为什么需要用到父子容器？
   通常我们使用 springmvc 的时候，采用3层结构，controller 层，service 层，dao 层；
   父容器中会包含 dao 层和 service 层，而子容器中包含的只有 controller 层；
   这2个容器组成了父子容器的关系，controller 层通常会注入 service 层的 bean。
   采用父子容器可以避免有些人在 service 层去注入 controller 层的 bean，导致整个依赖层次是比较混乱的。
   父容器和子容器的需求也是不一样的，比如父容器中需要有事务的支持，会注入一些支持事务的扩展组件，
   而子容器中 controller 完全用不到这些，对这些并不关心，子容器中需要注入一下 springmvc 相关的 bean，
   而这些 bean 父容器中同样是不会用到的，也是不关心一些东西，将这些相互不关心的东西隔开，可以有效的避免一
   些不必要的错误，而父子容器加载的速度也会快一些。
 */
// Spring的容器 不扫描 controller; 父容器
@ComponentScan(value = "com.atguigu", excludeFilters = {
        @Filter(type = FilterType.ANNOTATION, classes = {Controller.class})
})
public class RootConfig {

}