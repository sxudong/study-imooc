'循环一千次
'判断：如果D2等于“表名”then
'          计算一下  一车间表里有多少行  k，获取行数
'          D2 COPY到 一车间表的 k + 1 行
'结束循环

####################################
' 拆成一张表的复制
'
Sub chaifen()
Dim i, j, k As Integer

For i = 2 To Sheets1.Range("a65536").End(xlUp).Row
    IF Sheet1.Range("d" & i) = Sheets(2).Name Then
        k = Sheets(2).Range("a65536").End(xlUp).Row
        Sheet1.Range("d" & i).EntireRow.Copy Sheets(2).Range("a" & k + 1)
    End If
Next

End Sub

####################################
'拆分
Sub chaifen()
Dim i, j, k As Integer

Call clear  '调用下面的清空方法

For j = 2 To Sheets.Count
    For i = 2 To Sheets1.Range("a65536").End(xlUp).Row
        k = Sheets(j).Range("a65536").End(xlUp).Row
        Sheet1.Range("d" & i).EntireRow.Copy Sheets(j).Range("a" & k + 1)
    Next
Next

End Sub

'
' 清空内容
'
'
Sub clear()

For i = 2 To Sheets.Count
    Sheets.Range("a2.f10000").ClearContents
Next

End Sub


Sub 用循环拆分()
Dim i, j As Integer

For i = 2 To Sheet1.Range("a65535").End(xlUp).Row
    j = Sheets(Sheet1.Range("d" & i).Value).Range("a65535").End(xlUp).Row + 1
    Sheet1.Range("a" & i).EntireRow.Copy Sheets(Sheet1.Range("d" & i).Value).Range("a" & j)
Next

End Sub

Sub 清空结果()
Dim sht As Worksheet
For Each sht In Worksheets
    
    If sht.Name <> "数据" Then sht.Range("a2:f10000").ClearContents

Next

End Sub

'
' 用筛选的方式筛选
'
'
Sub 用筛选拆分()
Dim i As Integer
Dim sht As Worksheet

i = Sheet1.Range("a65535").End(xlUp).Row
For Each sht In Worksheets
    If sht.Name <> 数据 Then
    
        Sheet1.Range("a1:f" & i).AutoFilter field:=4, Criteria1:="=" & sht.Name
        Sheet1.Range("a1:f" & i).Copy sht.Range("a1")
    
    End If
Next

Sheet1.Range("a1:f" & i).AutoFilter
End Sub
