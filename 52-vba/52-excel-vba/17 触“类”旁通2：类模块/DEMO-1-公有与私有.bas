
Dim i            '类变量
Public j         '全局变量
Dim c As Integer '类变量

'==================================================
'默认是Public
Sub test()
    c = 5
    'MsgBox c
    Debug.Print c  '5
End Sub


'==================================================
'测试全局变量c
Sub test_variable_c()

    Call test
    
    'MsgBox c
    Debug.Print c  '5

End Sub


'==================================================
'模块内总调用方法
Public Sub test1()

    Call test
    
End Sub


'==================================================
'私有方法
Private Sub test2()

    'MsgBox "aa"
    Debug.Print "aa"  'aa
    
End Sub


'==================================================
'调用模块内私有方法
Sub test5()

    Call test2

End Sub


'==================================================
'取变量,先运行test()给c赋值
Function getVariable()

    getVariable = c
    
    Debug.Print getVariable  '5
    
End Function