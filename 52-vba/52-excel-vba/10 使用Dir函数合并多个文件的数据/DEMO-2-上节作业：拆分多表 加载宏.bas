'
'拆分数据
'
'
Sub chaifenshuju()

Dim sht As Worksheet
Dim k, i, j As Integer
Dim irow As Integer '这个说的是一共多少行
Dim l As Integer
Dim sht0 As Worksheet

Set sht0 = ActiveSheet  '“当前页”表对象赋值给sht0

l = InputBox("请输入你要按哪列分")


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

irow = sht0.Range("a65536").End(xlUp).Row
'拆分表
For i = 2 To irow
    k = 0
    For Each sht In Sheets
        If sht.Name = sht0.Cells(i, l) Then
            k = 1
        End If
    Next
    
    If k = 0 Then
        Sheets.Add after:=Sheets(Sheets.Count)
        Sheets(Sheets.Count).Name = sht0.Cells(i, l)
    End If

Next

'拷贝数据

For j = 2 To Sheets.Count
    sht0.Range("a1:z" & irow).AutoFilter Field:=l, Criteria1:=Sheets(j).Name  'A-Z范围扩大
    sht0.Range("a1:z" & irow).Copy Sheets(j).Range("a1")
Next

sht0.Range("a1:z" & irow).AutoFilter

sht0.Select

MsgBox "已处理完毕，牛逼不"

End Sub