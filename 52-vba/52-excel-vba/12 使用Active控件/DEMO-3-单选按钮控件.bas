'
'OptionButton2_Click 单选按钮控件OptionButton1
'
Private Sub OptionButton1_Click()

    MsgBox "已选择男性"

End Sub

'#####################################
'
' OptionButton2_Click 单选按钮控件OptionButton2
'
Private Sub OptionButton2_Click()

    MsgBox "已选择女性"

End Sub



'#####################################

'
'OptionButton1.Value = True 已选择 False 未选择
'
Sub test()

If Sheet1.OptionButton1.Value = True Then
    MsgBox "男性"
ElseIf Sheet1.OptionButton2.Value = True Then
    MsgBox "女性"
Else
    MsgBox "未选择性别"
End If

End Sub