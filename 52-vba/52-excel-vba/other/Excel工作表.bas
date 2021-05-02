'判断工作表是否存在
Sub CheckSheetExist()
    Dim X As Integer
    For X = 1 To Sheets.Count
        If Sheets(X).Name = "A" Then
            MsgBox "A工作表存在"
            Exit Sub
        End If
    Next
    MsgBox "A工作表不存在"
End Sub

'---------------------------------------------------------------------------------------------------------
'插入工作表
Sub s2()
    Dim sh As Worksheet
    Set sh = Sheets.Add
    sh.Name = "模板"
    sh.Range("a1") = 100
End Sub

'---------------------------------------------------------------------------------------------------------
'隐藏工作表
Sub s3()
    Sheets(2).Visible = True
End Sub

'---------------------------------------------------------------------------------------------------------
'移动工作表
Sub s4()
    Sheets("Sheet2").Move before: = Sheets("sheet1") 'sheet2移动到sheet1前面
    Sheets("Sheet1").Move after: = Sheets(Sheets.Count) 'sheet1移动到所有工作表的最后面
End Sub

'---------------------------------------------------------------------------------------------------------
'检查工作表是否保护
If ActiveSheet.ProtectContents Or ActiveSheet.ProtectDrawingObjects Then
    MsgBox "工作表已保护,本程序拒绝执行！", 64, "友情提示": Exit Sub


'---------------------------------------------------------------------------------------------------------
'破解工作表密码
Sub 删除密码()

    '运行本代码后跳出的输入密码对话框里,点击取消即可删除密码
    ActiveSheet.Protect DrawingObjects: = True, Contents: = True, AllowFiltering: = True
    ActiveSheet.Protect DrawingObjects: = False, Contents: = True, AllowFiltering: = True
    ActiveSheet.Protect DrawingObjects: = True, Contents: = True, AllowFiltering: = True
    ActiveSheet.Protect DrawingObjects: = False, Contents: = True, AllowFiltering: = True
    ActiveSheet.Unprotect
End Sub


Sub RemoveShProtect() ’'
    Dim i1 As Integer, i2 As Integer, i3 As Integer
    Dim i4 As Integer, i5 As Integer, i6 As Integer
    Dim i7 As Integer, i8 As Integer, i9 As Integer
    Dim i10 As Integer, i11 As Integer, i12 As Integer
    On Error Resume Next

    If ActiveSheet.ProtectContents = False Then
        MsgBox "该工作表没有保护密码！"
        Exit Sub
    End If

    For i1 = 65 To 66: For i2 = 65 To 66: For i3 = 65 To 66
        For i4 = 65 To 66: For i5 = 65 To 66: For i6 = 65 To 66
            For i7 = 65 To 66: For i8 = 65 To 66: For i9 = 65 To 66
                For i10 = 65 To 66: For i11 = 65 To 66: For i12 = 32 To 126
                    ActiveSheet.Unprotect Chr(i1) & Chr(i2) & Chr(i3) & Chr(i4) & Chr(i5) _
                             & Chr(i6) & Chr(i7) & Chr(i8) & Chr(i9) & Chr(i10) & Chr(i11) & Chr(i12)
                    If ActiveSheet.ProtectContents = False Then
                        MsgBox "已经解除了工作表保护！"
                        Exit Sub
                    End If
                Next : Next : Next : Next : Next : Next
Next : Next : Next : Next : Next : Next
End Sub
'---------------------------------------------------------------------------------------------------------



