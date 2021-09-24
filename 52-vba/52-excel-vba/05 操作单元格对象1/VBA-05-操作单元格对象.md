# 05 第五课 操作单元格对象1
## 1）“单元格”的常见表示方式

```vb
[A1]         //这个方式不支持变量
Cells(1,1)   //可以使用变量
Range("A1")  //可以使用变量
```

## 2）“单元格”对象常用操作

 .Select        //选中  
 .Delete       //删除
 .Copy          //复制 如：range("a10").copy 
 .AutoFilter  //自动筛选
 .ClearContents  //清空

## 3）“单元格”对象常用属性

  值、内容文字、单元格格式
 帮助重新定位：偏移、边界
 区域选区：选择整行、选择整列

- 1.帮助重新定位
    Range("a1").offset(10,0) //以A1为基准，第一个参数向下偏移，第二个参数向右偏移。
    Range("a10").End (xlUp)  //A列最后一个被使用的单元格

- 2.区域选区：
    Range("a10").EntireRow //整行
    Range("a10").EntireColumn //整列
    Range("a10").resize(1,10) //参数1：几行  参数2：几列
    以A10为基准，第1行到第10列，A10到J10区域单元格被选中。

​        .Row //返回行号，如：Range("a10").row 返回10
​        .Rows  //工作表上所有的行，Worksheets("Sheet1").Rows(1) 返回Sheet1上的第一行
​        .Column  //返回列号
​        .Columns  //工作表上所有的列

- 3.复制：
    range("H7:L7").Copy Range("N7") // "H7:L7"复制到目标地址N7

- 4.其它
    .Value  //数值
    .Text    //内容文字 
    单元格格式 
    如：
    [a1].NumberFormatLocal = "@" '设置A1单元格为文本格式
    [b1].NumberFormatLocal = "yyyy/m/d" '设置B1单元格为日期格式
    [c1].NumberFormatLocal = "[$-F400]h:mm:ss AM/PM" '设置C1单元格为时间格式
    [d1].NumberFormatLocal = "0.00%" '设置D1单元格为百分比格式
    [e1].NumberFormatLocal = "0.00E+00" '设置E1单元格为科学记数法格式
    [f1].NumberFormatLocal = "G/通用格式" '设置F1单元格为常规格式 



## 4）调用其它Sub函数

Call clear