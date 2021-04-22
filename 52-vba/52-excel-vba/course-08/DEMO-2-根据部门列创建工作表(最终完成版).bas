'拆分数据
'
Sub chaifenshuju()

Dim sht As Worksheet
Dim k, i, j As Integer
Dim irow As Integer   '这个说的是一共多少行
Dim l

l = InputBox("请输入你要按哪列分")

'vba.Information.IsNumeric()函数 判断是否是数字 或者 少于1，如果不是结束整个过程
If IsNumeric(l) = False Or l < 1 Then
    Exit Sub
End If


l = Val(l)  '转换为数字 另一种方法：l * 1


'删除无意义的表
Application.DisplayAlerts = False
If Sheets.Count > 1 Then
    For Each sht1 In Sheets
        If sht1.Name <> "数据" Then
            sht1.Delete
        End If
    Next
End If
Application.DisplayAlerts = True '这个地方上课的时候我没改成true，请大家注意一下


irow = Sheet1.Range("a65536").End(xlUp).Row
'拆分表
For i = 2 To irow
    k = 0
    For Each sht In Sheets
        If sht.Name = Sheet1.Cells(i, l) Then
            k = 1
        End If
    Next
    
    
    If k = 0 Then
        Sheets.Add after:=Sheets(Sheets.Count)
        Sheets(Sheets.Count).Name = Sheet1.Cells(i, l)
    End If

Next
'拷贝数据

For j = 2 To Sheets.Count
    Sheet1.Range("a1:f" & irow).AutoFilter Field:=l, Criteria1:=Sheets(j).Name
    Sheet1.Range("a1:f" & irow).Copy Sheets(j).Range("a1")
Next

Sheet1.Range("a1:f" & irow).AutoFilter

Sheet1.Select

MsgBox "已处理完毕，牛逼不"

End Sub