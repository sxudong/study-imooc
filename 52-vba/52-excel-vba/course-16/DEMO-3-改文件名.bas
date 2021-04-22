'用ExcelVBA来批量改文件名
'
Sub test()
	Dim i As Integer
	On Error Resume Next

	'改名 名字 + 身份证
	For i = 2 To 12
		'语法：  Name xxx As xxx
		Name "d:\data\" & Range("a" & i) & ".jpg" As "d:\data\" & Range("a" & i) & Range("d" & i) & ".jpg"
	Next
End Sub