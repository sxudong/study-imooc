Sub test()
    Dim str()
    Dim i As Integer
    Dim wb, wb1 As Workbook
    Dim sht As Worksheet

    On Error Resume Next '这一句上课时候没加，加上以后防止点了取消发生的错误
    Set wb1 = ActiveWorkbook
    Set sht1 = ActiveSheet
    On Error Resume Next
    str = Application.GetOpenFilename("Excel数据文件,*.xls*", , , , True)

        For i = LBound(str) To UBound(str)
            Set wb = Workbooks.Open(str(i))
            For Each sht In wb.Sheets
                sht.Copy after:=wb1.Sheets(wb1.Sheets.Count)
                wb1.Sheets(wb1.Sheets.Count).Name = Split(wb.Name, ".")(0) & sht.Name
            Next
            wb.Close
        Next
End Sub

'===================================================

'这段代码如果制作成加载宏，不能用！哪里不一样呢？
'这里有一个关键指标放在加载宏里不能用,如果这个文件我另存为".xla"
'文件放在加载宏里，如果打开一个文件执行，它就会跑到另一个表里往
'这个表里执行操作。对于".xla"文件它只是一个第3者，它只是一个旁观者，
'对于".xla"来讲，它是对两个文件做操作，一个是目标文件，一个是源文件，
'把源文件拷到目标文件中。
'如果在代码里提到"ThisWorkbook"写代码的这个表，谁是写代码的这个表？
'实际上是说".xla"才是写代码的这个表。
Sub test2()
    Dim arr()
    Dim wb As Workbook

    arr = Application.GetOpenFilename("Excel文件,*.xls*", 2, , , True)

    If arr(1) <> "False" Then
        For i = LBound(arr) To UBound(arr)
            Set wb = Workbooks.Open(arr(i))
    '上面是壳子###################################################################

            For Each sht In wb.Sheets
                sht.Copy after:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count)
                ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count).Name = Split(wb.Name, ".")(0) & sht.Name
            Next

    '下面是壳子###################################################################
            wb.Close
        Next
    End If
End Sub

'===================================================


'制作成加载宏——在任意地方打开合并文件
'
'源文件：wb   新建的目标文件：wb1
'
'从wb拷贝到wb1中
'
Sub test3()
    Dim arr()
    Dim i As Integer
    Dim wb, wb1 As Workbook

    On Error Resume Next '这一句上课时候没加，加上以后防止点了取消发生的错误

    '新建一个工作薄，在新建文件中操作
    Set wb1 = Workbooks.Add

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