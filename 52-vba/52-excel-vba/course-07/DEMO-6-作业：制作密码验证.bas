' Workbook_BeforeClose 关闭工作薄事件 
Private Sub Workbook_BeforeClose(Cancel As Boolean)
Dim sht As Worksheet
'隐藏所有表
For Each sht In Sheets
    If sht.Name <> "登录界面" Then
        sht.Visible = xlSheetVeryHidden
    End If
Next
End Sub

' Workbook_Open 打开工作薄事件  
Private Sub Workbook_Open()
Dim i

i = InputBox("请输入密码")

If i = "123" Then
    Sheet1.Visible = xlSheetVisible
    Sheet2.Visible = xlSheetVisible
    Sheet3.Visible = xlSheetVisible
ElseIf i = "456" Then
    Sheet4.Visible = xlSheetVisible
    Sheet5.Visible = xlSheetVisible
    Sheet6.Visible = xlSheetVisible
Else
    MsgBox "密码输入错误"
    ThisWorkbook.Close
End If
        
End Sub