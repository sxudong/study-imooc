
'CommandButton1_Click 点击事件（要测试这个方法需要把下面移动的方法注销）
Private Sub CommandButton1_Click()
    'Range("c2") = 8
    MsgBox "这是一次点击"
End Sub

'############################################

' CommandButton1_MouseMove 鼠标悬停事件
Private Sub CommandButton1_MouseMove(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)

    Call test4  '鼠标悬念Button就移向下移动

End Sub



'############################################
'
'Caption是Button上的文字
'
Sub test1()

	Sheet1.CommandButton1.Caption = "结束"

End Sub

'
'Enabled可用性
'
Sub test2()

	Sheet1.CommandButton1.Enabled = False

End Sub

'
'设置CommandButton是否显示
'
Sub test3()

	Sheet1.CommandButton1.Visible = False

End Sub

'
'Top 与上边线距离
'
Sub test4()

	Sheet1.CommandButton1.Top = Sheet1.CommandButton1.Top + Sheet1.CommandButton1.Height

End Sub
