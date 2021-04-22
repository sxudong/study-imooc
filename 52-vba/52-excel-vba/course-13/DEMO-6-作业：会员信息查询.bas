'UserForm 窗体对象

Private Sub CommandButton1_Click()
	Dim rng As Range

	'用find方法做
	Set rng = Sheet1.Range("i1:i1000").Find(Me.TextBox1.Value)
	If rng Is Nothing Then
		MsgBox "无该用户"
	Else
		Me.Label3.Caption = rng.Offset(0, -6)
		Me.Label4.Caption = rng.Offset(0, -5)
		Me.Label6.Caption = rng.Offset(0, -4)
		Me.Label8.Caption = rng
		Me.Label10.Caption = rng.Offset(0, -3)
		Me.Label12.Caption = rng.Offset(0, -2)
		Me.Label13.Caption = rng.Offset(0, -1)
	End If
End Sub


'选择ListBox1中的值
Private Sub ListBox1_Click()
  '文本框中的值等于选择的ListBox1中的值
  Me.TextBox1 = Me.ListBox1.Value
  '隐藏列表框控件
  Me.ListBox1.Visible = False
End Sub

Private Sub TextBox1_Change()
	Dim arr()
	'如果值大于4,就把值拿到手机号列找一遍，看看那个字包含写的字符，
	'包含就加到列表框里
	If Len(TextBox1.Value) >= 4 Then
		'列表清空
		Me.ListBox1.Clear
		
		'For i = 2 To 8
		  'VBA中的字符串函数InStr()，如果包含我写入的值
		  'InStr 函数可返回一个字符串在另一个字符串中首次出现的位置。
		'  If InStr(Sheet1.Range("i" & i), Me.TextBox1.Value) > 0 Then
			'添加到列表项
		'    Me.ListBox1.AddItem Sheet1.Range("i" & i)
		'  End If
		'Next
		
		arr = Sheet1.Range("i2:i" & Sheet1.Range("a65536").End(xlUp).Row)
		For i = LBound(arr) To UBound(arr)
			If InStr(arr(i, 1), Me.TextBox1.Value) > 0 Then
			   Me.ListBox1.AddItem arr(i, 1)
		   End If
		Next
		
		'将列表项显示出来
		'如果列表数大于1，则列表框显示
		If Me.ListBox1.ListCount > 0 Then
		  Me.ListBox1.Visible = True
		End If
	Else
		Me.ListBox1.Clear '小于4列表清空
		Me.ListBox1.Visible = False

	End If
End Sub

'#############################################

'模块
Sub search()
    UserForm1.Show
End Sub
