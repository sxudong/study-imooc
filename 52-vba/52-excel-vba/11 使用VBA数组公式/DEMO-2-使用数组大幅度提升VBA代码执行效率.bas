'
'用循环的方法,效率低下
'
'
Sub test1()
Dim i, k
Dim t

t = Timer

For i = 2 To 200000
    If Range("g" & i) = Range("n5") Then
        k = k + Range("j" & i)
    End If
Next

Range("p5") = k

MsgBox Timer - t  '计算时间 6.18秒

End Sub

''''''''''''''''''''''''''''''''''''''''''
'
'用循环的方法,效率低下
'
'
Sub test2()
Dim i, k
Dim t
Dim str As String

t = Timer

'每次for循环到单元格里取值，20w次拖慢速度
str = Range("n5")

For i = 2 To 200000
    'If Range("g" & i) = Range("n5") Then
     If Range("g" & i) = str Then  '用字符串代替Range效率要高一点点
        k = k + Range("j" & i)
    End If
Next

Range("p5") = k

MsgBox Timer - t  '运行时间 3.5秒

End Sub


''''''''''''''''''''''''''''''''''''''''''
'
'数组 —— 将一个区域值定义到数组里
'
Sub test3()
Dim arr()

arr = Range("a1:d9")

Range("a12") = arr(7, 3)  '第7行，第3列

End Sub


''''''''''''''''''''''''''''''''''''''''''
'
'用数组提升效率
'
'
Sub test4()
Dim i, k
Dim t
Dim str As String
Dim arr()          '数组

t = Timer

arr = Range("G1:J200000")     '赋值给数组
str = Range("n5")
For i = 2 To 200000
    If arr(i, 1) = str Then   '第2行，第1列
        k = k + arr(i, 4)     '第2行，第4列
    End If
Next

Range("p5") = k

MsgBox Timer - t   '运行时间0.2秒

End Sub