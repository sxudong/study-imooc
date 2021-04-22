'拆分数据
Sub chaifenshuju()

Dim sht As Worksheet
Dim k, i, j As Integer
Dim irow As Integer    '这个说的是一共多少行
Dim l As Integer       '返回未来要输入的数字


l = InputBox("请输入你要按哪列分")


'1、删除无意义的表
Application.DisplayAlerts = False
If Sheets.Count > 1 Then             '如果表的数量大于1
    For Each sht1 In Sheets          '使用For Each删除表
        If sht1.Name <> "数据" Then  '表名不等于“数据”
            sht1.Delete
        End If
    Next
End If
Application.DisplayAlerts = True

irow = Sheet1.Range("a65536").End(xlUp).Row  '最后一行
'2、拆分创建表（从第2行开始）
For i = 2 To irow
    k = 0
    For Each sht In Sheets                     '循环表名是否有重复
        If sht.Name = Sheet1.Cells(i, l) Then  '用Cell来选择列
            k = 1                              '如果有相同的表名 k = 1
        End If
    Next
    
    If k = 0 Then                              '表没有重名，新建表
        Sheets.Add after:=Sheets(Sheets.Count)
        Sheets(Sheets.Count).Name = Sheet1.Cells(i, l) 'l对话框中输入的列值
    End If

Next

'3、拷贝数据
'
'从第2个表循环到最后一个表
'
For j = 2 To Sheets.Count
    '按表名筛选数据
    Sheet1.Range("a1:f" & irow).AutoFilter Field:=l, Criteria1:=Sheets(j).Name
    '复制数据
    Sheet1.Range("a1:f" & irow).Copy Sheets(j).Range("a1")
Next

'取消自动筛选
Sheet1.Range("a1:f" & irow).AutoFilter

Sheet1.Select

MsgBox "已处理完毕"
