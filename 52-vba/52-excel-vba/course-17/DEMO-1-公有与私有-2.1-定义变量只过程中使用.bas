'对变量而言，它具备3个范围：
'1、只在过程内部使用
'2、跨过程，在一个模块中使用
'3、Public各个模块都可以使用

Sub test()

    i = 1

    'MsgBox i
    Debug.Print i   '1

End Sub


'=================== Private =======================
'无法获取 i 的值，i的值只在test()方法中的过程中使用
Private Sub test2()
    'MsgBox i  '要先运行了test()方法,i才能获取到值“1”
    Debug.Print i  '1
End Sub

