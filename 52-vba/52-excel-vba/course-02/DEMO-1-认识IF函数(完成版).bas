'
'A1~A100 输入值
'
'
Sub shishi()
Dim i As Integer

For i = 1 To 100
Range("a" & i) = i * 100
Next

End Sub

#########################################
'
'改颜色
'
'
Sub gys()

Dim i As Integer

'For i = 1 To 100 Step 7

For i = 1 To 100

    '每隔 7 变蓝色
    Range("c" & i * 7 - 6).Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorLight2
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With

Next

End Sub

#########################################
'判断

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

#########################################
'工资条

Sub gzt()
Dim i As Integer

'3 5 7 9 ...步进2
For i = 3 To 2000 Step 2

    '如果是空，退出for循环
    If Range("A" & i) = "" Then
        Exit For
    End If

    Rows("1:1").Select
    Application.CutCopyMode = False
    Selection.Copy
    Range("A" & i).Select
    Selection.Insert Shift:=xlDown

Next

End Sub

#########################################
'恢复工资单

Sub gzd()

For i = 3 To 2000

    If Range("a" & i) = "" Then
        Exit For
    End If

    Range("A" & i).Select
    Application.CutCopyMode = False
    Selection.EntireRow.Delete
Next

End Sub
