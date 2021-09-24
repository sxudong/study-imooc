Sub 宏2()
'
' 录制宏2 宏
'

'
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorLight2
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    ActiveCell.Offset(7, 0).Range("A1").Select
End Sub

############################
' 改颜色
Sub gys()
Dim i As Integer
For i = 1 To 50
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorLight2
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    ActiveCell.Offset(7, 0).Range("A1").Select
Next

End Sub


############################
Sub 宏1()
'
' 录制宏1 宏
'

'
    Selection.Copy
    Rows("3:3").Select
    Selection.Insert Shift:=xlDown
End Sub


############################
Sub 工资条()

Dim i As Integer    '定义变更 i 是整数

For i = 1 To 10     '范围1到10
    Selection.Copy
    Rows("3:3").Select
    Selection.Insert Shift:=xlDown
Next

End Sub

############################
' 优化代码后的工资条
Sub gzt2()
Dim i As Integer
Rows("1:1").Select
For i = 1 To 10
    Selection.Copy
    ActiveCell.Offset(2, 0).Rows("1:1").EntireRow.Select
    Selection.Insert Shift:=xlDown
Next
End Sub

