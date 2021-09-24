'找“分组框”与别的图形的差异
'
Sub test1()
	Dim shp As Shape

	For Each shp In Sheet2.Shapes

		'第一种隐藏方式
		i = i + 1
		Range("g" & i) = shp.Name '所有组框名字都带有“Group Box”

	Next

End Sub


'==================================================
'
'隐藏组框
'
Sub HideGroupShapes()
	Dim shp As Shape
	Dim i As Integer

	For Each shp In Sheet1.Shapes

		'第一种隐藏方式
		i = i + 1
		Range("g" & i) = shp.Name '所有组框名字都带有“Group Box”

		If shp.Name Like "Group Box*" Then
			shp.Visible = msoFalse
		End If

		'第二种隐藏方式（Sheet2表中的这种方式运行有bug，在Sheet3表中运行无碍）
		If shp.FormControlType = xlGroupBox Then
			shp.Visible = msoFalse
		End If
	Next

End Sub

'==================================================
'
'根据 Sheet1 自动生成 Sheet2 问答卷
'
'
Sub test2()
	Dim i As Integer
	Dim shp, shp1

	'加图片前，删除表中所以图片
	For Each shp1 In Sheet2.Shapes
		shp1.Delete
	Next

	Sheet2.Range("a1:z10000").ClearContents


	For i = 2 To 18

		'题目
		Sheet2.Range("a" & i * 6 - 11) = Sheet1.Range("a" & i)

		'添加组框，并隐藏
		Set shp = Sheet2.GroupBoxes.Add(Sheet2.Range("b" & i * 6 - 10).Left, Sheet2.Range("b" & i * 6 - 10).Top, 182, 72)
		shp.Visible = msoFalse

		'调用test3()方法生成选项按钮
		Sheet2.Range("b" & i * 6 - 10) = Sheet1.Range("b" & i)
		Call test3(Sheet2.Range("b" & i * 6 - 10))
		Sheet2.Range("b" & i * 6 - 10).ClearContents

		Sheet2.Range("b" & i * 6 - 9) = Sheet1.Range("c" & i)
		Call test3(Sheet2.Range("b" & i * 6 - 9))
		Sheet2.Range("b" & i * 6 - 9).ClearContents

		Sheet2.Range("b" & i * 6 - 8) = Sheet1.Range("d" & i)
		Call test3(Sheet2.Range("b" & i * 6 - 8))
		Sheet2.Range("b" & i * 6 - 8).ClearContents

		Sheet2.Range("b" & i * 6 - 7) = Sheet1.Range("e" & i)
		Call test3(Sheet2.Range("b" & i * 6 - 7))
		Sheet2.Range("b" & i * 6 - 7).ClearContents

	Next

End Sub


'==================================================
'生成“选项按钮”
Sub test3(rng As Range)
	Dim shp
	'OptionButtons 选项按钮
	Set shp = Sheet2.OptionButtons.Add(rng.Left, rng.Top, rng.Width, rng.Height)
	shp.Characters.Text = rng
End Sub


'==================================================
Sub test4()

    Call test3(Sheet2.Range("b2"))

End Sub