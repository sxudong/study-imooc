Sub 宏1()
'
' 宏1 录制的表
'
    Selection.AutoFilter
    ActiveSheet.Range("$A$1:$F$1048").AutoFilter Field:=4, Criteria1:="一车间"
End Sub


###################################
'
'新建表
'
'1、判断是否有表与A1列重名的
'2、如果没有重名的就创建表
'A1=3月 A2=4月 A3=4月
Sub xinjianbiao()
Dim sht As Worksheet
Dim k As Integer

'循环A1到A3的表名
For i = 1 To 3
    '第二次循环时恢复为0
    k = 0
    '循环工作薄中所有的表
    For Each sht In Sheets
        If sht.Name = Sheet1.Range("a" & i) Then
            k = 1  '如果有重名的表 k = 1
        End If
    Next
    
    '如果k为0，就创建表
    If k = 0 Then
        Sheets.Add after:=Sheets(Sheets.Count)
        'Sheets.Add(after:=Sheets(Sheets.Count)) = "345" 简写
        Sheets(Sheets.Count).Name = Sheet1.Range("a" & i)
        Debug.Print Sheets(Sheets.Count).Name ‘' 3月 4月 4月
    End If

Next

End Sub
