'
'获取“表名”保存到单元格A列中
'
'
Sub getSheetName()
Dim i As Integer

For i = 2 To Sheets.Count
    Range("a" & i - 1) = Sheets(i).Name
Next

End Sub