Sub 宏1()
'
' 宏1 录制的表
'
    Selection.AutoFilter
    ActiveSheet.Range("$A$1:$F$1048").AutoFilter Field:=4, Criteria1:="一车间"
End Sub

##################################
' 筛选
Sub shaifen()
Dim i As Integer

'循环所有的表
For i = 2 To Sheets.Count
    '过滤第4列
    Sheet1.Range("a1:f1048").AutoFilter Field:=4, Criteria1:=Sheets(i).Name
    Sheet1.Range("a1:f1048").Copy Sheets(i).Range("a1")
Next
'取消筛选
Sheet1.Range("a1:f1048").AutoFilter

End Sub


##################################
' 新建表
Sub xinjianbiao()
Dim sht As Worksheet
Dim k As Integer

For i = 1 To 3
    k = 0
    For Each sht In Sheets
        If sht.Name = Sheet1.Range("a" & i) Then
            k = 1
        End If
    Next
       
    If k = 0 Then
        Sheets.Add after:=Sheets(Sheets.Count)
        Sheets(Sheets.Count).Name = Sheet1.Range("a" & i)
    End If

Next

End Sub


##################################
'最终完成

Sub chaifenshuju() '拆分数据

Dim sht As Worksheet
Dim k, i, j As Integer
Dim irow As Integer '这个说的是一共多少行


irow = Sheet1.Range("a65536").End(xlUp).Row
'拆分表
For i = 2 To irow
    k = 0
    For Each sht In Sheets
        If sht.Name = Sheet1.Range("d" & i) Then
            k = 1
        End If
    Next
    
    If k = 0 Then
        Sheets.Add after:=Sheets(Sheets.Count)
        Sheets(Sheets.Count).Name = Sheet1.Range("d" & i)
    End If

Next
'拷贝数据

For j = 2 To Sheets.Count
    Sheet1.Range("a1:f" & irow).AutoFilter Field:=4, Criteria1:=Sheets(j).Name
    Sheet1.Range("a1:f" & irow).Copy Sheets(j).Range("a1")
Next

Sheet1.Range("a1:f" & irow).AutoFilter

End Sub












