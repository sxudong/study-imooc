'
'ԭ�����ɱ�ķ�ʽ
'
'
Sub test()

    Sheets.Add after:=Sheets(Sheets.Count)
    Sheets(Sheets.Count).Name = "1��"

End Sub

############################
'
'������ֵ������
'
'
Sub createSheets()
Dim sht As Worksheet

For i = 2 To 5
    '������ֵ������
    Set sht = Sheets.Add
    sht.Name = Sheet1.Range("a" & i)
Next

End Sub