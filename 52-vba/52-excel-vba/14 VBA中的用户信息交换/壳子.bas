Sub test()
    Dim arr()
    Dim wb As Workbook

    arr= Application.GetOpenFilename("Excel文件,*.xls*", 2, , , True)

    If arr<> "False" Then
        For i = LBound(arr) To UBound(arr)
            Set wb = Workbooks.Open(arr(i))
    '上面是壳子###################################################################




    '下面是壳子###################################################################
            wb.Close
        Next
    End If
End Sub