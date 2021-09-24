# 03 第三课 操作工作表——小结
## 1）Worksheets 工作表对象的“动作”和“属性”？

 - 可以执行的动作有哪些？
    Select、Add、Delete、Copy

 - 有哪些属性？
    Count、Name

    

## 2）有一张表Sheets("1月")，它有几种叫法？分别是？

```vb
  Sheets1
  Sheets("1月")
  Sheets(1)
```

## 3）关闭 Application 主程序对象 屏幕刷新和弹出的警告窗口？

```vb
 关闭屏幕刷新：
 Excel.Application.SreenUpdating = False
 程序运行结束后再打开：
 Excel.Application.SreenUpdating = True

 关闭弹出警告窗口：
 Excel.Application.DisplayAlerts = False
 程序运行结束后再打开：
 Excel.Application.DisplayAlerts = True
```

## 4）需要理解并记住写法的概念

​      Application   代表整个Excel应用程序。
​      Worksheets  代表工作表对象。

**还有其它的常用对象，如：**
    Workbook：代表Excel工作簿对象。
    Window：代表窗口对象。
    Range：代表单元格对象。
    Shape：代表嵌入到工作表中的图形对象，包括自选图形、OLE对象、图片、图表、艺术文字、文本框、批注等。
   Chart：代表图表对象。
   WorksheetFunction：代表工作表函数对象。
   Comment：代表单元格中的批注对象。

## 5）需要理解的概念

​      什么是对象、属性、方法
## 6）对象的操作方法是？

对象.动作方法

## 7）参数与属性的赋值方式？

"参数"赋值用":=" ，参数之前用逗号隔 "," 开。
"属性"赋值用"="

## 8）Worksheets与Sheets的区别？

没有区别，一样的。