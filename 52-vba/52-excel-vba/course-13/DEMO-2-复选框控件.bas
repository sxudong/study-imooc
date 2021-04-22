'Thisbook

'关闭时隐藏表格并锁表
Private Sub Workbook_BeforeClose(Cancel As Boolean)
  Sheet2.Visible = xlSheetHidden
  Sheet3.Visible = xlSheetHidden
  
  Sheet2.Protect "test"  '锁表密码
  Sheet2.Protect "test"
End Sub

Private Sub Workbook_Open()
  UserForm1.Show '打开文档显示窗口
End Sub
