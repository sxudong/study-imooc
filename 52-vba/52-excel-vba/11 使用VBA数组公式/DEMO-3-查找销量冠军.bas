Sub test()
Dim arr() '定义不定大小数组
Dim j, i As Integer

'计算需要定义多大
j = Range("a65536").End(xlUp).Row - 1

'重新定义数组大小
ReDim arr(1 To j)

For i = 1 To j
    arr(i) = Range("b" & i + 1) * Range("c" & i + 1)
Next

'最大数
Range("h3") = Application.WorksheetFunction.Max(arr)

'查找位置，找一个值在一列当中第几个，Match函数，在arr中找，0精确匹配
'得到的只是在数组中的位置，所以要加“1”得到在表中的行号
Range("h2") = Range("a" & Application.WorksheetFunction.Match(Range("h3"), arr, 0) + 1)


MsgBox LBound(arr) '数组的下限

MsgBox UBound(arr) '数组的上限

End Sub