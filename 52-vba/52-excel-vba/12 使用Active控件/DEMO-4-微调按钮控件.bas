
'
'SpinButton1_Change 微调按钮控件 SpinButton1
'
Private Sub SpinButton1_Change()

    Call test1

End Sub

'#################################

'
'最大值最小值
'
Sub test()

    Sheet1.SpinButton1.Min = 1
    Sheet1.SpinButton1.Max = 10

End Sub

'
'值写入到A1单元格
'
Sub test1()
    
    Range("a1") = Sheet1.SpinButton1.Value

End Sub
