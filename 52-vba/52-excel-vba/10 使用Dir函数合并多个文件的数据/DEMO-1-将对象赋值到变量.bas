'
'原来生成表的方式
'
'
Sub test()

    Sheets.Add after:=Sheets(Sheets.Count)
    Sheets(Sheets.Count).Name = "1月"

End Sub

############################
'
'将对象赋值到变量
'
'
Sub createSheets()
Dim sht As Worksheet

For i = 2 To 5
    '将对象赋值到变量
    Set sht = Sheets.Add
    sht.Name = Sheet1.Range("a" & i)
Next

End Sub