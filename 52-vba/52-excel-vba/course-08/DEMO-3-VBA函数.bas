'zhangsan@163.com => zhangsan
'
Sub test()
Dim strString As String
'Left()函数，可从字符串的左侧返回指定数目的字符。
'VBA.Strings.InStr() 文本函数，指定一个字符串在另一个字符串中首次出现的位置，返回一个Long值。
strString = Left(Sheet1.Range("a2"), InStr(Sheet1.Range("a2"), "@") - 1)
Debug.Print strString

End Sub

'
'zhangsan@163.com => 9
'
'VBA.Strings.InStr() 文本函数，指定一个字符串在另一个字符串中首次出现的位置，返回一个Long值。
'
Sub test2()

Dim i As Integer
i = InStr(Sheet1.Range("a2"), "@")
Debug.Print i

End Sub

'PW-023-2015-37-001 => 2015年 第37周
'
Sub tiqu()

On Error Resume Next

For i = 2 To Sheet2.Range("a65536").End(xlUp).Row

    'VBA.Strings.Split() 文本函数按“-”分开，取第2段和第3段
    Sheet2.Range("b" & i) = Split(Sheet2.Range("a" & i), "-")(2) & "年 第" & Split(Sheet2.Range("a" & i), "-")(3) & "周"
    Debug.Print Sheet2.Range("b" & i)
Next

End Sub