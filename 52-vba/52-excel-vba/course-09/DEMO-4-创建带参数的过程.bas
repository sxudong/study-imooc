'
'创建表（带参数的方法）
'
'
Sub cjb(str As String)
Dim sht As Worksheet

For Each sht In Sheets

    If sht.Name = str Then
        k = 1
    End If

Next

If k = 0 Then
    '在最后一张表格后面创建
    Sheets.Add after:=Sheets(Sheets.Count)
    Sheets(Sheets.Count).Name = str
End If

End Sub

###########################################
'
'调用带参数的 cjb()函数 创建表过程
'
'
Sub abc1()
  Call cjb(Sheet1.Range("a1"))
  Sheet1.Select
End Sub

###########################################
'
'调用带参数的 cjb()函数 创建表过程
'
'
Sub abc2()
    Call cjb(Sheet2.Range("a8"))
    Sheet2.Select
End Sub
