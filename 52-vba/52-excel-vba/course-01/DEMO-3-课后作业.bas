'相对引用 改颜色
Sub gys()
Dim shu As Integer  'Dim定义属性

For shu = 1 To 50
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorLight2
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    '向下偏移7，向右偏移0
    ActiveCell.Offset(7, 0).Range("A1").Select
Next

End Sub


#################################################

'工资条
Sub gzt()

Dim i As Integer

Rows("1:1").Select
For i = 1 To 10
    Selection.Copy
    ActiveCell.Offset(2, 0).Rows("1:1").EntireRow.Select
    Selection.Insert Shift:=xlDown
Next

End Sub

#################################################

'恢复工资表
Sub gzb()
Dim i As Integer
Rows("3:3").Select
For i = 1 To 10
    Application.CutCopyMode = False
    Selection.Delete Shift:=xlUp
    ActiveCell.Offset(1, 0).Rows("1:1").EntireRow.Select
Next
End Sub
