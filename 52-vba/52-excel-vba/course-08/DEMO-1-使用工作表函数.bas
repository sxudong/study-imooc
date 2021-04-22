'
'统计
'
Sub count()
Dim i, k, l, m As Integer

For i = 2 To Sheets.count
    'CountA()函数、CountIf()函数
    k = k + Application.WorksheetFunction.CountA(Sheets(i).Range("a:a")) - 1      '累加总计
    l = l + Application.WorksheetFunction.CountIf(Sheets(i).Range("f:f"), "男")   '累加F列男性人数
    m = m + Application.WorksheetFunction.CountIf(Sheets(i).Range("f:f"), "女")   '累加F列女性人数
Next

Sheet1.Range("d26") = k
Sheet1.Range("d27") = l
Sheet1.Range("d28") = m

End Sub


'
'根据“输入准考证号”查询
'
Sub query()

On Error Resume Next   '错误回避，当发生错误时继续执行下一行代码

Sheet1.Range("d14").ClearContents  '循环之前清空D14单元格

For i = 2 To Sheets.count
    'VLookup() 第一参数：D9 第二参数：范围 第三参数：返回第几列 第四参数：精确匹配
    Sheet1.Range("d14") = Application.WorksheetFunction.VLookup(Sheet1.Range("d9"), Sheets(i).Range("a:h"), 5, 0)
    Sheet1.Range("d16") = Application.WorksheetFunction.VLookup(Sheet1.Range("d9"), Sheets(i).Range("a:h"), 6, 0)
    Sheet1.Range("d18") = Application.WorksheetFunction.VLookup(Sheet1.Range("d9"), Sheets(i).Range("a:h"), 3, 0)
    Sheet1.Range("d20") = Application.WorksheetFunction.VLookup(Sheet1.Range("d9"), Sheets(i).Range("a:h"), 8, 0)
    Sheet1.Range("d22") = Sheets(i).Name  '地区是表名
    
    '找到了就停止循环，还节省性能
    If Sheet1.Range("d14") <> "" Then  '如果不为空，退出For循环
        Exit For
    End If
Next

End Sub
