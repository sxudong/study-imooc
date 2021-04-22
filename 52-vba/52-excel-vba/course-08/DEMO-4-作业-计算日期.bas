'
'转换   20140808 => 2014/8/8
'
'和Excel函数date同样功能的VBA函数DateSerial用法
'
'vba.year,month,day,这些属性虽然要求填写date类型的值，但是填入文本型也是可以的。
'dateserial 属性可以是integer，这个长整型，可以是时间格式，可以是文本格式的数字，可以是数字格式的。
'
Sub zhuanhua()

With Sheet1
    For i = 2 To .Range("a65536").End(xlUp).Row
        .Range("b" & i) = DateSerial(Left(.Range("a" & i), 4), Mid(.Range("a" & i), 5, 2), Right(.Range("a" & i), 2))
        Debug.Print Range("b" & i)
    Next
End With

End Sub

'
'提取生日
'420203198808089201 => 1988/8/8
'
Sub tiqushengri()

With Sheet2

    For i = 2 To .Range("a65536").End(xlUp).Row
        .Range("b" & i) = DateSerial(Mid(.Range("a" & i), 7, 4), Mid(.Range("a" & i), 11, 2), Mid(.Range("a" & i), 13, 2))
        Debug.Print Range("b" & i)
    Next
End With

End Sub