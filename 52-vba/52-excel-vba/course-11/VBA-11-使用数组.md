# 11 第十一课 使用VBA数组公式

## 1）认识VBA数组及常用操作
 1、什么是数组？

​       就是一组集合。讲师的定义是一大组变量。

 2、如何定义数组？

```vb
Dim arr() As String
```

 3、动态数组与静态数组？

​    动态数组大小不固定，引用区域赋值。例如：

```vb 
Dim arr() 
arr = Range("a1:a5")
```

​     静态数组是固定的，然后把值一个一个往里面放。

 4、计算数组的大小` Ubound`上标和`Lbound`下标

​       MsgBox LBound(arr)  '数组的下限
​       MsgBox UBound(arr) '数组的上限

 5、重定义数组大小  ReDim [Preserve]  Arr(10) 

```vb
'计算需要定义多大
j = Range("a65536").End(xlUp).Row - 1
ReDim arr(1 To j)
```

## 2）数组应用实例解析
 1、如何将区域赋值给数组

​    声明数组：Dim arr()
​    数组赋值：arr = Range("a1:a5")
​    引用区域所产生的数组都是二维数组，不管区域是横向的还是纵向的，包含多少行、多少列。

 2、数组的维度

 - 一维数组（一维只有横向数组） 
    Dim arr(rows) 
      例如声明带有5个元素的一维数组，有以下两种方式：

    ```vb
    Dim arr(1 To 5)
    Dim arr(4)
    ```

      这两种声明方式区别是采用的索引号不同。

 - 二给数组
   Dim arr(rows, columns) 
   两种声明方式：

   ```vb
   Dim arr(4, 2) 
   Dim arr(1 To 5, 1 To 3)
   ```

   这两种声明方式区别是采用的索引号不同。

 3、给数组赋值与取值

​      通过下标赋值与取值，也可以通过引用区域赋值与取值。

```vb
 arr = Range("a1:a5")
 Range("D1:G3") = arr 
 Range("c1") = arr(2, 1)
```

3）Timer定时器函数 和 GOTO 100

​      Timer定时器函数返回自12:00 AM秒到现在的毫秒数。

