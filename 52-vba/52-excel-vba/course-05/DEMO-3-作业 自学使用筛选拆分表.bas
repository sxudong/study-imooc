Sub 宏1()
'
' 录制宏1 宏
'

'
    Range("A1").Select
    Range(Selection, Selection.End(xlToRight)).Select
    Range(Selection, Selection.End(xlDown)).Select
    Selection.AutoFilter
    ActiveSheet.Range("$A$1:$F$1048").AutoFilter Field:=4, Criteria1:="一车间"
End Sub



Sub 用筛选拆分()
Dim i As Integer
Dim sht As Worksheet

i = Sheet1.Range("a65535").End(xlUp).Row '获取a列最后一个单元格数
For Each sht In Worksheets
    If sht.Name <> "数据" Then
    
        Sheet1.Range("a1:f" & i).AutoFilter Field:=4, Criteria1:="=" & sht.Name  '选择a1到f末尾区域筛选
        Sheet1.Range("a1:f" & i).Copy sht.Range("a1")  '复制
        
    End If
Next

Sheet1.Range("a1:f" & i).AutoFilter  '取消筛选
End Sub
