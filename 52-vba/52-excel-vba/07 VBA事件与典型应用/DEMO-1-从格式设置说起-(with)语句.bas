Sub 录制宏4()
'
' 改背景颜色
'

'
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 65535
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
End Sub

Sub 录制宏5()
'
' 清空表格中背景颜色
'

'
    With Cells.Interior
        .Pattern = xlNone
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
End Sub

'从录制的宏中复制动作代码过来使用
'
Sub gys() '改颜色

Cells.Interior.Pattern = xlNone
Selection.EntireRow.Interior.Color = 65535

End Sub

Sub 宏1()
'
' 录制宏1 宏
'

'
    With Selection.Font
        .Name = "Arial"
        .Size = 18
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
End Sub

Sub test2()
'
' 传统方式
'
    Sheet2.Range("a1") = 6
    Sheet2.Range("a2") = 16
    Sheet2.Range("a4") = 11
    Sheet2.Range("a7") = 3
    
End Sub

Sub test3()
'
' With语句
'

'
With Sheet2
    .Range("a1") = 6
    .Range("a2") = 16
    Sheet3.Range("a1") = 3
    .Range("a4") = 11
    .Range("a7") = 3
End With

End Sub

Sub shishi()
Range("a1").Font.Size = 18

End Sub

' Worksheet_SelectionChange事件
Private Sub Worksheet_SelectionChange(ByVal Target As Range)
'调用方法改颜色
Call gys
End Sub


