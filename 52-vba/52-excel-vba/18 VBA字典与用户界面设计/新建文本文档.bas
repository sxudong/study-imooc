Sub test()
	Dim arr()
	Dim dic As New Dictionary

	arr = Range("a2:b13")
	For i = LBound(arr) To UBound(arr)
		dic(arr(i, 2)) = 1
	Next

	Sheet2.ListBox1.List = dic.Keys
	
End Sub