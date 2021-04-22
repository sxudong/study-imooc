'
'多表汇总
'
'
'循环 2 到 sheets.count
'取值
'
'结束循环
'

Sub summary()

Dim i As Integer

For i = 2 To Sheets.Count
    Sheet1.Range("b" & i + 8) = Sheets(i).Range("e5")
    Sheet1.Range("c" & i + 8) = Sheets(i).Range("e6")
    Sheet1.Range("d" & i + 8) = Sheets(i).Range("e44")
Next

End Sub
