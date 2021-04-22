'UerForm1 窗体对象

'关闭Excel文档时，隐藏表格和对表格加锁保护
Private Sub Workbook_BeforeClose(Cancel As Boolean)
  Sheet2.Visible = xlSheetVeryHidden
  Sheet3.Visible = xlSheetVeryHidden

  '保护工作表，审阅->保护工作表->输入密码
  Sheet2.Protect "test"
  Sheet3.Protect "test"
End Sub

'打开Excel文档时显示登录窗体
Private Sub Workbook_Open()
  UserForm1.Show
End Sub

'#########################################
'ThisWorkbook 工作薄对象

Private Sub CommandButton1_Click()
'判断用户名和密码
If UserForm1.TextBox1.Value = "张三" And UserForm1.TextBox2.Value = "123" Then
    '取消工作表保护，审阅->取消工作表保护->输入密码
    Sheet2.Unprotect Password:="test"
	'显示表格
    Sheet2.Visible = xlSheetVisible
	'关闭窗体
    Unload UserForm1
ElseIf UserForm1.TextBox1.Value = "李四" And UserForm1.TextBox2.Value = "0000" Then
    '取消工作表保护，审阅->取消工作表保护->输入密码
    Sheet3.Unprotect Password:="test"
	'显示表格
    Sheet3.Visible = xlSheetVisible
	'关闭窗体
    Unload UserForm1
End If

End Sub