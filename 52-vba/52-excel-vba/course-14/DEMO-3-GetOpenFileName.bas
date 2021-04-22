'
'GetOpenFilename (文件类型，优先类型，对话框标题，按钮文字，是否支持多选)
'
'
Sub test()
    Range("a1") = Application.GetOpenFilename
End Sub

'====================================================

'打开单个文件并关闭
Sub test1()
    Dim str As String
    Dim wb As Workbook

    str = Application.GetOpenFilename("Excel文件,*.xls*", , "请选择") '限制只能打开excel文件

    'Range("a1") = str '不选文件时返回的是False

    If str <> "False" Then
        Set wb = Workbooks.Open(str) '不是False，才可以打开文件

    '#######################
    '这里针对打开的WB进行操作
    '#######################

        wb.Close
    End If
End Sub

'====================================================

'打开多选的文件
Sub test2()
    Dim arr()   '定义数组
    Dim wb As Workbook
    On Error Resume Next '这一句上课的时候没加
    arr = Application.GetOpenFilename("Excel文件,*.xls*", , "请选择", , True)

    'Range("a1:b1") = str '结果是一组数据
    'MsgBox LBound(arr)   '查看数组文件的最小下标

    If arr(1) <> "False" Then
        For i = LBound(arr) To UBound(arr)   '从arr最小的下标循环到最大的下标
            Set wb = Workbooks.Open(arr(i))  '打开文件


    '#######################
    '这里针对打开的WB进行操作
    '#######################


            wb.Close
        Next

    End If
End Sub