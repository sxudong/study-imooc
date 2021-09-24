Sub test3()
    Dim arr()
    Dim i As Integer
    Dim wb, wb1 As Workbook

    On Error Resume Next '这一句上课时候没加，加上以后防止点了取消发生的错误

    Set wb1 = Workbooks.Add '新建一个工作薄，在新建文件中操作

    arr = Application.GetOpenFilename("Excel数据文件,*.xls*", , , , True)

    If arr(1) <> "False" Then

        For i = LBound(arr) To UBound(arr)
            Set wb = Workbooks.Open(arr(i))
            For Each sht In wb.Sheets
                sht.Copy after:=wb1.Sheets(wb1.Sheets.Count)
                wb1.Sheets(wb1.Sheets.Count).Name = Split(wb.Name, ".")(0) & sht.Name
            Next
            wb.Close
        Next

    End If

End Sub