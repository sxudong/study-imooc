'拆分数据
Sub chaifenshuju()

Dim sht As Worksheet
Dim k, i, j As Integer
Dim irow As Integer '这个说的是一共多少行
Dim l As Integer
Dim str As String '这里是第1处修改，加入一个变量，用于提取当前工作表的名字￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥

str = ActiveSheet.Name '这里是第2处修改，取得当前要处理的表的名字￥￥￥￥￥￥￥￥￥￥￥￥

l = InputBox("请输入你要按哪列分")


'删除无意义的表
Application.DisplayAlerts = False
If Sheets.Count > 1 Then
    For Each sht1 In Sheets
        If sht1.Name <> str Then '这里是第3处修改，不在用“数据”这个固定的名字了，而是用之前取到的名字￥￥￥￥￥￥￥￥￥￥￥
            sht1.Delete
        End If
    Next
End If
Application.DisplayAlerts = True '这个地方上课的时候我没改成true，请大家注意一下




irow = Sheets(str).Range("a65536").End(xlUp).Row '这里是第4处修改，不在用“sheet1”这个固定的表名字了，而是用之前取到的名字的表￥￥￥￥￥￥￥￥￥￥￥
'拆分表
For i = 2 To irow
    k = 0
    For Each sht In Sheets
        If sht.Name = Sheets(str).Cells(i, l) Then '这里是第5处修改，跟第四个修改一样，把原来的sheet1替换成sheets(str)￥￥￥￥￥￥￥￥￥￥￥
            k = 1
        End If
    Next
    
    
    If k = 0 Then
        Sheets.Add after:=Sheets(Sheets.Count)
        Sheets(Sheets.Count).Name = Sheets(str).Cells(i, l)   '这里是第6处修改，跟第四个修改一样，把原来的sheet1替换成sheets(str)￥￥￥￥￥￥￥￥￥￥￥
    End If

Next
'拷贝数据   注意：第7处修改。原有的Range("a1:f" & irow)已经改为Range("a1:z" & irow)  因为数据可能会列数很多，所以写成到z列，故意多写一些。￥￥￥￥￥￥￥￥￥￥￥￥￥

For j = 2 To Sheets.Count
    Sheets(str).Range("a1:z" & irow).AutoFilter Field:=l, Criteria1:=Sheets(j).Name  '这里是第8处修改，跟第四个修改一样，把原来的sheet1替换成sheets(str)￥￥￥￥￥￥￥￥￥￥￥
    Sheets(str).Range("a1:z" & irow).Copy Sheets(j).Range("a1")  '这里是第9处修改，跟第四个修改一样，把原来的sheet1替换成sheets(str)￥￥￥￥￥￥￥￥￥￥￥
Next

Sheets(str).Range("a1:z" & irow).AutoFilter   '这里是第10处修改，跟第四个修改一样，把原来的sheet1替换成sheets(str)￥￥￥￥￥￥￥￥￥￥￥

Sheets(str).Select   '这里是第11处修改，跟第四个修改一样，把原来的sheet1替换成sheets(str)￥￥￥￥￥￥￥￥￥￥￥

MsgBox "已处理完毕，牛逼不"

End Sub
