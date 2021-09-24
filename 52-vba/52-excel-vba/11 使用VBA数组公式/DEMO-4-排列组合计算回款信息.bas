
'
'用最笨的方法
'
'
Sub test1()

Dim i, j, k, l As Integer

t = Timer

For i = 2 To 80
    For j = 2 To 80
        For k = 2 To 80
            For l = 2 To 80
            
                If Range("a" & i) + Range("a" & j) + Range("a" & k) + Range("a" & l) = 124704 Then
                    Range("f3") = Range("a" & i)
                    Range("g3") = Range("a" & j)
                    Range("h3") = Range("a" & k)
                    Range("i3") = Range("a" & l)
                    GoTo 100  '跳出循环
                End If
            Next
        Next
    Next
Next

100

MsgBox Format(Timer - t, "0.00000")  '3.29344秒

End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
'用数组的方式
'
'
Sub test2()

Dim i, j, k, l As Integer
Dim arr()

t = Timer

arr = Range("a1:a80")  '赋值给数组，这是一个二维数组

For i = 2 To 80
    For j = 2 To 80
        For k = 2 To 80
            For l = 2 To 80
            
                If arr(i, 1) + arr(j, 1) + arr(k, 1) + arr(l, 1) = 124704 Then
                    Range("f3") = arr(i, 1)
                    Range("g3") = arr(j, 1)
                    Range("h3") = arr(k, 1)
                    Range("i3") = arr(l, 1)
                    GoTo 100 '跳出循环
                End If
            Next
        Next
    Next
Next

100
MsgBox Format(Timer - t, "0.00000")  '0.01563秒，是上一个的300倍

End Sub
