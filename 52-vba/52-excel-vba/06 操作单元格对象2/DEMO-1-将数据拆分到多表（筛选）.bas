'筛选
Sub shaifen()
Dim i As Integer

'循环所有的表
For i = 2 To Sheets.Count
    '过滤第4列
    Sheet1.Range("a1:f1048").AutoFilter Field:=4, Criteria1:=Sheets(i).Name
    Sheet1.Range("a1:f1048").Copy Sheets(i).Range("a1")
Next

'取消筛选
Sheet1.Range("a1:f1048").AutoFilter

End Sub


