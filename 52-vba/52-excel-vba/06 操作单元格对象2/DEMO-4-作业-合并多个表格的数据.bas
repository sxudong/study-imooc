'合并多个表格的数据
Sub hebing()
Dim i, j As Integer   'i是数据源表的最后一行，j是目标表(数据表)的最后一行
Dim sht As Worksheet


'先要删除所有数据
Sheet1.Range("a1:f65536").ClearContents

'复制表头（表2复制到表1）
Sheet2.Range("a1:f1").Copy Sheet1.Range("a1")

'复制数据
For Each sht In Sheets
    If sht.Name <> "数据" Then
        '复制表的A列最后一行值
        i = sht.Range("a65536").End(xlUp).Row
        '表1的A列最一个值
        j = Sheet1.Range("a65536").End(xlUp).Row
        
        sht.Range("a2:f" & i).Copy Sheet1.Range("a" & j + 1)
    End If
Next
End Sub

'#################################################################################################
'隐藏任务：

'因为工作中的表，表头不一定只有一行，能不能执行程序以前弹出inputbox，问一下用户表头有几行，然后再合并
'如果表头有两行，则其他表数据要从第三行开始取
'#################################################################################################