'
'代码逻辑：
'
'循环31次
'
'新建表       (在所有表后面)
'最后这张表。 名字 = 5月x日
'表的E5单元格 = 2016-5-x
'
'结束循环
'
'
Sub sc()
Dim i As Integer

For i = 1 To 31
    Sheets.Copy after:=Sheets(Sheets.Count)
    Sheets.Count(Sheets.Count).Name = "5月" & i & "日"
Next

End Sub