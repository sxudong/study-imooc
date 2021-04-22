# 10 第十课 使用Dir函数合并多个文件的数据
## 1) Set把一个对象放到变量里

### 将对象赋值到变量

  - 将单元格赋值到变量

    ```vb
    Dim rng As Range
    Set rng = Range("d:d").Find(Range("l3"))
    ```

  - 将工作表赋值到变量

    ```vb
    Dim sht0 As Worksheet
    Set sht0 = ActiveSheet
    '删除无意义的表，不删除“当前页表”
    Application.DisplayAlerts = False
    If Sheets.Count > 1 Then
        For Each sht1 In Sheets
            If sht1.Name <> sht0.Name Then
                sht1.Delete
            End If
        Next
    End If
    Application.DisplayAlerts = True 
    ```

  - 将工作簿赋值到变量

    ```vb
    Dim wb As Workbook
    str = Dir("E:\data\*.*")
    Set wb = Workbooks.Open("E:\data\" & str)
    ```

## 2）认识Dir函数

 - Dir函数验证是否存在某个文件

   ```vb
   Sub test1()
   Dim i As Integer
   For i = 1 To 5
      If Dir("E:\data\" & Range("A" & i) & ".xlsx") = "" Then
          Range("A" & i) = "无此文件"
      Else
          Range("A" & i) = "有文件"
      End If
   Next
   End Sub
   ```

 - 多个条件相符的文件 Dir如何返回值？

   ```vb
   '两个文件"苏州.xls"、"苏州.xlsx"
   Range("A1") = Dir("E:\data\苏州.xls*") '返回"苏州.xls"
   Range("A2") = Dir  '返回"苏州.xlsx"
   Range("A3") = Dir  '返回空 
   Range("A4") = Dir  '程序报错 - Dir函数遍历循环所有文件
   ```

 - Dir函数遍历循环所有文件

   ```vb
       Sub test()
       Dim str As String
       Dim wb As Workbook
       Dim i As Integer
   
       str = Dir("d:\data\*.*")
       '遍历所有的文件
       For i = 1 To 100
           Set wb = Workbooks.Open("d:\data\" & str)
   
           '这里该干什么干什么
   
           wb.Close
           str = Dir
           If str = "" Then
               Exit For
           End If
       Next
       End Sub
   ```

## 3）多文件合并

 - 多个文件 每个文件中一张表

   DEMO-4-多文件合并1.xlsm

 - 多个文件 每个文件中若干张表

   DEMO-5-多文件合并2.xlsm

 - 合并后的命名问题

   DEMO-5-多文件合并2.xlsm

需要记住的：
SET sht = sheet1
Dir (“D:\data\*.*”)
Range(“a:a”).find（“张三”)

Dir代码 -- 壳子

```vb
Sub test()
Dim str As String
Dim wb As Workbook
Dim i As Integer

str = Dir("d:\data\*.*")
For i = 1 To 100
    Set wb = Workbooks.Open("d:\data\" & str)
    '这里该干什么干什么
    wb.Close
    str = Dir
    If str = "" Then
        Exit For
    End If
Next
End Sub
```



FIND代码

```vb
Sub test()
Dim rng As Range

Set rng = Range("d:d").Find(Range("l3"))
    If Not rng Is Nothing Then
        Range("m3") = rng.Offset(0, 3)
    End If

End Sub
```

