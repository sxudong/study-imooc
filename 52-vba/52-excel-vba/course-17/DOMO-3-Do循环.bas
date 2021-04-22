Sub test1()

    '循环一100遍，它有尽头
    For i = 1 To 100
        InputBot "请输入密码"
    Next

End Sub


'==================================================
'Do循环没有尽头
Sub test2()

    Do
        InputBot "请输入密码"
    Loop

End Sub


'==================================================
'Do循环,等于“123”就结束
Sub test3()

    Do
        If InputBox("请输入密码") = "123" Then
            Exit Do
        End If
    Loop

End Sub


'==================================================
'Do循环,等于“123”就结束
Sub test4()

    Do While InputBox("请输入密码") <> "123"
    
    Loop

End Sub