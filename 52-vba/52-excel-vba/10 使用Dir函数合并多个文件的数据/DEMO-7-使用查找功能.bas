'
'查找
'
'
Sub chazhao()
Dim rng As Range

Set rng = Range("d:d").Find(Range("L3"))

'如果rng不为空
If Not rng Is Nothing Then
    '找到值后，rng偏移3个单元格获取分数值
    Range("m3") = rng.Offset(0, 3)
End If

End Sub

####################################
'L3 = 李庆
Sub query()
Dim rng As Range

'取到的是单元格数值“李庆”
Range("I1") = Range("d:d").Find(Range("L3"))

'返回的是这个单元格对象
Set rng = Range("d:d").Find(Range("L3"))
Range("I2") = rng.Row    '14
Range("I3") = rng.Column '4
Range("I4") = rng.Value  '李庆

End Sub