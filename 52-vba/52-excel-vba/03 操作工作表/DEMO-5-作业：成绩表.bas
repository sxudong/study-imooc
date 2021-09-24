'成绩表
Sub test()
Dim i As Integer
Dim j As Integer

For j = 1 To Sheets.Count
    
    For i = 100 To 2 Step -1
        '如果E列单元格内是“男”，则F列称呼列的单元格则填“男士”，否则填“女士”
        If Sheets(j).Range("e" & i) = "男" Then
            Sheets(j).Range("f" & i) = "先生"
        Else
            Sheets(j).Range("f" & i) = "女士"
        End If
        
        '如果B列专业类单元格内是“理工”，则C列专业代号的单元格则填“LG”
        If Sheets(j).Range("b" & i) = "理工" Then
            Sheets(j).Range("c" & i) = "LG"
            
        '如果B列专业类单元格内是“文科”，则C列专业代号的单元格则填“WK”
        ElseIf Sheets(j).Range("b" & i) = "文科" Then
            Sheets(j).Range("c" & i) = "WK"
        Else
            Sheets(j).Range("c" & i) = "CJ" '否则则C列专业代号的单元格则填“CJ”
        End If
        
        '如果D列姓名列为空，则删除整行
        If Sheets(j).Range("d" & i) = "" Then
            Sheets(j).Range("d" & i).EntireRow.Delete
        End If
    Next

Next

End Sub