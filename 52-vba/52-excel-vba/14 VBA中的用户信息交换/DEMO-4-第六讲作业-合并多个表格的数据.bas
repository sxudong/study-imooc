Sub test()
    Dim str As String
    Dim wb As Workbook
    Dim Sht, sht1 As Worksheet
    Dim i, j

    Set sht1 = ActiveSheet
    str = Application.GetOpenFilename

    If str <> "False" Then
        Set wb = Workbooks.Open(str)
    '上面是壳子###################################################################

            For Each Sht In wb.Sheets
                Sht.Range("a1:z1").Copy sht1.Range("a1") '复制表头 到 当前表第一行
                i = Sht.Range("a65536").End(xlUp).Row    '循环表中的A列最后一行
                j = sht1.Range("a65536").End(xlUp).Row   '当前表的A列最后一行

                Sht.Range("a2:z" & i).Copy sht1.Range("a" & j + 1)  '复制来源表中数据到 当前表中最后一列
            Next

    '下面是壳子###################################################################
        wb.Close
    End If
End Sub