
'第2节课代码
Sub pd()
Dim i As Integer

'从下往上删除 步进-1
For i = 26 To 2 Step -1
    '处理性别的代码
    If Range("e" & i) = "男" Then
        Range("f" & i) = "先生"
    Else
        Range("f" & i) = "女士"
    End If
    
    '处理专业代号
    If Range("b" & i) = "理工" Then
        Range("c" & i) = "LG"
    ElseIf Range("b" & i) = "文科" Then
        Range("c" & i) = "WK"
    Else
        Range("c" & i) = "CJ"
    End If
        
    '如果是空,则删除
    If Range("d" & i) = "" Then
        Range("D" & i).Select
        Selection.EntireRow.Delete
    End If
Next


End Sub

##########################################
Sub chuli()
Dim i, j As Integer

For j = 1 To Sheets.Count

For i = 26 To 2 Step -1
    '处理性别的代码
    If Sleets(j).Range("e" & i) = "男" Then
        Sleets(j).Range("f" & i) = "先生"
    Else
        Sleets(j).Range("f" & i) = "女士"
    End If
    
    '处理专业代号
    If Sleets(j).Range("b" & i) = "理工" Then
        Sleets(j).Range("c" & i) = "LG"
    ElseIf Sleets(j).Range("b" & i) = "文科" Then
        Sleets(j).Range("c" & i) = "WK"
    Else
        Sleets(j).Range("c" & i) = "CJ"
    End If
        
    '如果是空,则删除
    If Sleets(j).Range("d" & i) = "" Then
        '先点表，才可以点单元格
        Sheets(j).Select
        Sleets(j).Range("D" & i).Select
        Selection.EntireRow.Delete
    End If
Next

Next

End Sub

##########################################
Sub handle()
Dim i As Integer
Dim sht As Worksheet


For Each sht In Sheets

For i = 100 To 2 Step -1
    '处理性别的代码
    If sht.Range("e" & i) = "男" Then
        sht.Range("f" & i) = "先生"
    Else
        sht.Range("f" & i) = "女士"
    End If
    
    '处理专业代号
    If sht.Range("b" & i) = "理工" Then
        sht.Range("c" & i) = "LG"
    ElseIf sht.Range("b" & i) = "文科" Then
        sht.Range("c" & i) = "WK"
    Else
        sht.Range("c" & i) = "CJ"
    End If
        
    '如果是空,则删除
    If sht.Range("d" & i) = "" Then
        '先点表，才可以点单元格
        sht.Select
        sht.Range("D" & i).Select
        sht.Range("D" & i).EntireRow.Delete
    End If
Next

Next

End Sub

##########################################
Sub test()
Dim i As Integer
Dim sht As Worksheet

For Each sht In Worksheets
    '选中当前表
    sht.Select
    
    '从下往上删除 步进-1
    For i = 100 To 2 Step -1
        '处理性别的代码
        If Range("e" & i) = "男" Then
            Range("f" & i) = "先生"
        Else
            Range("f" & i) = "女士"
        End If
        
        '处理专业代号
        If Range("b" & i) = "理工" Then
            Range("c" & i) = "LG"
        ElseIf Range("b" & i) = "文科" Then
            Range("c" & i) = "WK"
        Else
            Range("c" & i) = "CJ"
        End If
            
        '删除空行
        If Range("d" & i) = "" Then
            Range("D" & i).Select
            Selection.EntireRow.Delete
        End If
    Next
    
    '拆分表
    sht.Copy
    ActiveWorkbook.SaveAs Filename:="E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\04第四课\完成版\data\" & sht.Name & ".xlsx"
    ActiveWorkbook.Close
    
Next

End Sub


