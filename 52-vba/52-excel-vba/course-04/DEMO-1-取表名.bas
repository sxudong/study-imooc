'
'获取sheets表名，在“部门”表里面执行
'
'
Sub getSheetName()

Dim sht As Worksheet
Dim i As Integer

For Each sht In Worksheets
    '部门表是第一张表
    If sht.Name <> "部门" Then
        i = i + 1
        Range("a" & i) = sht.Name
		Debug.Print Range("a" & i)
    End If
Next

End Sub
'Output:
'安防
'特气
'制粉
'一室
'三室
'五室
'七室
'十室

####################################
'
'For循环
'
'
'
Sub test()

Dim i As Integer

For i = 1 To 10
    Range("a" & i) = i
    Debug.Print Range("a" & i)
Next

End Sub
'Output:
'1
'2
'3
'4
'5
'6
'7
'8
'9
'10

####################################
'
'高级For循环
''
Sub advancedFor()

Dim ge As Range
Dim i As Integer

For Each ge In Range("a1:a10")
    
    i = i + 1
    ge = i
    Debug.Print ge
Next

End Sub
'Output:
'1
'2
'3
'4
'5
'6
'7
'8
'9
'10

