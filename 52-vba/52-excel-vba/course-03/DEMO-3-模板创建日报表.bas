'
'模板创建日报表
'
'
'循环31次
'
' 复制表  （在所有表后面）
' 最这张表。名字=5月x日
' 表的E5单元格=2016-5-x
'
'结束循环
'
Sub createDaily()

Dim i As Integer

For i = 1 To 31
    Sheet1.Copy after:=Sheets(Sheets.Count)
    Sheets(Sheets.Count).Name = "5月" & i & "日"
    Sheets(Sheets.Count).Range("e5") = "2016-5-" & i
Next

End Sub