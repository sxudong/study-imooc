
'第一位以J开头
'
Sub test01()
    Dim i, j

    'Interior.Pattern 表示内部图案设置为无颜色（通过手动录制宏得到）
    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "J*" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D2") = k

End Sub


'==================================================
'第一位以J开头并且7个字符
'
Sub test02()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "J??????" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D3") = k

End Sub


'==================================================
'第一位以J开头、7个字符、第五位是w
'
Sub test03()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "J???w??" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D4") = k

End Sub


'==================================================
'第一位以A-M开头
'
Sub test04()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "[A-M]*" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D6") = k

End Sub


'==================================================
'第一位以大写字母开头
'
Sub test05()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "[A-Z]*" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D7") = k

End Sub


'==================================================
'第一位以字母开头
'
Sub test06()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "[A-Za-z]*" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D8") = k

End Sub


'==================================================
'第一位以数字开头
'
Sub test07()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "[0-9]*" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D10") = k

End Sub


'==================================================
'前两位以数字开头
'
Sub test08()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "[0-9][0-9]*" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D11") = k

End Sub


'==================================================
'第一位以数字开头 第二位不是数字的
'
Sub test09()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "[0-9][!0-9]*" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D12") = k

End Sub


'==================================================
'第一位以J开头、7个字符、第五位是字母
'
Sub test10()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "J???[A-Z a-z]??" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D14") = k

End Sub


'==================================================
'开头结尾是大写字母 并且7位
'
Sub test11()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "[A-Z]?????[A-Z]" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D15") = k

End Sub


'==================================================
'第一位不是字母
'
Sub test12()
    Dim i, j

    Range("a2:a15").Interior.Pattern = xlNone
    For i = 2 To 15

    If Range("a" & i) Like "[!A-Z a-z]*" Then

        Range("a" & i).Interior.Color = 65535
        k = k + 1

    End If
    Next

    Range("D16") = k

End Sub