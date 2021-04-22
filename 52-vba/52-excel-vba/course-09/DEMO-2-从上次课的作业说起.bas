'
'转换
'
'
Sub zhuanhua()

With Sheet1

    For i = 2 To .Range("a65536").End(xlUp).Row
         '嵌套使用自定义的“日期转换”函数
        .Range("b" & i) = rqzh(Range("a" & i))
    Next
End With

End Sub

###############################
'
'提取生日
'
'
Sub tiqushengri()

With Sheet2

    For i = 2 To .Range("a65536").End(xlUp).Row
         '嵌套使用自定义的“日期转换”函数
        .Range("b" & i) = rqzh(Mid(Range("a" & i), 7, 8))
    Next
End With

End Sub

###############################
'
'日期转换
'
'DateSerial()函数可以把年、月、日合并为日期
'
Function rqzh(str As String)
  'Mid()从左侧第5位开始截取
  rqzh = DateSerial(Left(str, 4), Mid(str, 5, 2), Right(str, 2))
End Function