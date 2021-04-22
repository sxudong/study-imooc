

# 07 第七课 VBA事件与典型应用

## 1）关于单元格格式设置中的WITH语句

 专门用于简化引用并提升效率而存在的，当某个对象重复出现时就有必要使用With语句。语法如下：

```vb
 With object
        [statements] //代表针对object而执行的一条或多条语句。
 End With
```



```vb
With Selection
        .HorizontalAlignment = xlRight  水平对齐方式
        .VerticalAlignment = xlCenter   垂直对齐方式
        .WrapText = False               自动换行
        .Orientation = 0                文字方向
        .AddIndent = False              缩进
        .IndentLevel = 0                缩进量
        .ShrinkToFit = False            缩小字体填充
        .ReadingOrder = xlContext       文字方向
        .MergeCells = False             合并单元格
End With
```

- Format函数  格式化日期时间数字函数

  语法：*Format(值, 格式（可选参数))*

- NOW() 函数  返回当前的日期和时间



## 2）常用事件

- Worksheet_SelectionChange事件

  在选区变化换时触发执行（Demo1-高亮显示当前单元格正行数据）

- Worksheet_Change事件

  在改变单元格时触发（Demo2-输入条件后自动完成筛选）

- Worksheet_Activate事件

  在激活工作表时触发 （Demo3-数据透视表自动更新）

- Workbook_BeforeSave事件

  在保存工作簿之时触发（Demo4-为重要文件制作文件恢复节点）

- Workbook_Open事件（DEMO-6-作业：制作密码验证.xls）

  工作簿(或加载项)打开时，该事件被触发

## 3）事件的禁用与启用

   Application.EnableEvents = True
   Application.EnableEvents = False 

## 4）ThisWorkbook.SaveCopyAs 另存为

 范例：ThisWorkbook.SaveCopyAs "E:\data\" & Format(Now(), "yyyymmddhhmmss") & ".xls" 



## 5）表单控件和ActiveX控件

 - 表单控件，简单，直接指定一个宏就可以使用。
 - ActiveX控件，比较复杂，不可以指定宏。会在Sheets对象会多出一个CommandButton按钮对象，右边多出很多事件。

