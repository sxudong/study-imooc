# 01 第一课 第一次编写代码-for——小结
## 1）需要记录的概念
Sub函数语法

```vb
Sub ABC()
    ……
End Sub
```

声名变量:

```vb
Dim i 
```

For循环语法

```vb
For i= 1 to 10
    ……
Next
```

## 2）需要理解的概念

1. 什么是宏？

   所谓宏，就是一些命令组织在一起，作为一个单独命令完成一个特定任务；

2. 什么是VBA？

     VBA is an acronym for Visual Basic for Applications. 其实就是用代码操作Excel。

   - 录制宏时的相对引用是什么意思？

     选中一个单元格 -> 录制宏 -> 使用相对引用 -> 点击下一个单元格位置（所谓的相对位置） -> 结束录制宏

3. 什么是变量？

   ```vb
   Dim i As Integer
   ```

4. 关于文件格式和宏安全性？

   别人的电脑要使用宏需要启用一个设置：文件 -> 选项 -> 信任中心 -> 宏设置 -> 启用所有宏

5. 设置宏按钮属性“大小位置固定”？

   选中“宏按钮”右键选择“设置控件格式” -> 属性 -> 大小位置均固定