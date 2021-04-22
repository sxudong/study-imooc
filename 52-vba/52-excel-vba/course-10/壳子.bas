'判断是否有文件
Sub test1()
Dim i As Integer
For i = 1 To 5
	If Dir("E:\data\" & Range("A" & i) & ".xlsx") = "" Then
		Range("A" & i) = "无此文件"
	Else
		Range("A" & i) = "有文件"
	End If
Next
End Sub


Sub test2()

'两个文件"苏州.xls"、"苏州.xlsx"
Range("A1") = Dir("E:\data\苏州.xls*") '返回"苏州.xls"
Range("A2") = Dir  '返回"苏州.xlsx"
Range("A3") = Dir  '返回空 
Range("A4") = Dir  '程序报错

End Sub



Sub test()
Dim str As String
Dim wb As Workbook

'Dir里面是多个文件，每次返回一个文件
str = Dir("d:\data\*.xls*")

For i = 1 To 100
'============ 壳子 ============ 

	'Range("A" & i) = str '文件名保存到单元里
	
    '打开表
    Set wb = Workbooks.Open("d:\data\" & str)
    '半闭表
    wb.Close

'============ 壳子 ============ 	
	
	'重新给str赋值,第2个文件,3个，4个...
    str = Dir 
	
	'如果Dir返回空了，退出循环
    If str = "" Then
        Exit For
    End If
Next

End Sub




Sub wjhb()
Dim str As String
Dim wb As Workbook

str = Dir("d:\data\*.xls*")

For i = 1 To 100
    Set wb = Workbooks.Open("d:\data\" & str)
    
    wb.Sheets(1).Copy after:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count)
    ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count).Name = Split(wb.Name, ".")(0)
    
    wb.Close
    str = Dir
    If str = "" Then
        Exit For
    End If
Next
End Sub


