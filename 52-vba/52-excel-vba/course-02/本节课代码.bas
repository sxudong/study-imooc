' 判断
'
' 需求：
' "专业代号"如果是理工则是"LG", 文科"WK", 财经"CJ"
' "称呼"如果是"男", 则称呼"男士", "女"则称呼"女士"
' 
Sub pd()
Dim i As Integer

 ' 从下往上删除，上面的行号不会变，只是下面的变。
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
        
    If Range("d" & i) = "" Then     ' 空
        Range("D" & i).Select
        Selection.EntireRow.Delete
    End If
        
Next

End Sub

#########################################
' 工资条
' 
Sub gzt()
Dim i As Integer

' 从第3行开始，跟相对引用就没关系了
For i = 3 To 2000 Step 2          

    If Range("A" & i) = "" Then  ' 空（递规思路）
        Exit For                            ' 退出循环
    End If
    
    Rows("1:1").Select
    Application.CutCopyMode = False
    Selection.Copy
    Range("A" & i).Select
    Selection.Insert Shift:=xlDown
    
Next

End Sub

#########################################
'
'个税计算
'
Sub gs()

Dim i As Integer
For i = 2 To 12

If Range("c" & i) - 3500 <= 0 Then
    Range("d" & i) = 0
ElseIf Range("c" & i) - 3500 > 0 And Range("c" & i) - 3500 <= 1500 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.03
ElseIf Range("c" & i) - 3500 > 1500 And Range("c" & i) - 3500 <= 4500 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.1 - 105
ElseIf Range("c" & i) - 3500 > 4500 And Range("c" & i) - 3500 <= 9000 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.2 - 555
ElseIf Range("c" & i) - 3500 > 9000 And Range("c" & i) - 3500 <= 35000 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.25 - 1005
ElseIf Range("c" & i) - 3500 > 35000 And Range("c" & i) - 3500 <= 55000 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.3 - 2755
ElseIf Range("c" & i) - 3500 > 55000 And Range("c" & i) - 3500 <= 80000 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.35 - 5505
Else
    Range("d" & i) = (Range("c" & i) - 3500) * 0.45 - 13505
End If

Next
    
End Sub