package uml.three;

import java.util.List;

/**
 * 关联（Association)、聚合（Aggregation）、组合(Composition)
 *
 * 1) 区别
 * 三者在代码上的表现相同，只是语意上有所差别。
 *   组合：整体和部分同生共死，部分无法离开整体单独存在
 *   聚合：部分可以离开整体单独存在
 *   关联：代表一种拥有关系
 *
 * 2) 代码（体现在成员变量中）
 *
 * 三种类型在IntelliJ IDEA均以实线 + 菱形箭头 + 普通箭头表示，菱形箭头指向整体，
 * 普通箭头指向部分，箭头两端的数字表示实例的个数.
 */


//父母类
public class Parent {
    
    //可以拥有多个孩子
    public List<Child> children;
    //可以拥有手机
    public CellPhone cellPhone;

}

// 一个父母可以有多个孩子（1 *），可以有一部手机（1 1）。每个孩子都有一个父母（1 1）

