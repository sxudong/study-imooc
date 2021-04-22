'Workbook_Open 工作薄打开事件
Private Sub Workbook_Open()
    '显示窗口
	UserForm1.Show
End Sub


'CommandButton1_Click点击按钮事件 弹出另一个窗口
Private Sub CommandButton1_Click()
    UserForm2.Show
End Sub


'UserForm_Activate事件 激活时关闭Excel主文档
Private Sub UserForm_Activate()
    Application.Visible = False
End Sub


'UserForm_QueryClose事件 关闭窗口时离开时，关闭Excel主文档
Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    Application.Quit
End Sub
