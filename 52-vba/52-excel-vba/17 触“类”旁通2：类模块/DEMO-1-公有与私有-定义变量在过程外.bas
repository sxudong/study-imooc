'对变量而言，它具备3个范围：
'1、只在过程内部使用
'2、跨过程，在一个模块中使用
'3、Public各个模块都可以使用


Dim str As String  '值保存在内存里

'==================================================
Sub test1()
    str = InputBox("请输入考生名")
End Sub


'==================================================
Sub test2()
    'MsgBox str
    Debug.Print str
End Sub