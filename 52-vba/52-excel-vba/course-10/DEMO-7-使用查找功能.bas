'
'����
'
'
Sub chazhao()
Dim rng As Range

Set rng = Range("d:d").Find(Range("L3"))

'���rng��Ϊ��
If Not rng Is Nothing Then
    '�ҵ�ֵ��rngƫ��3����Ԫ���ȡ����ֵ
    Range("m3") = rng.Offset(0, 3)
End If

End Sub

####################################
'L3 = ����
Sub query()
Dim rng As Range

'ȡ�����ǵ�Ԫ����ֵ�����족
Range("I1") = Range("d:d").Find(Range("L3"))

'���ص��������Ԫ�����
Set rng = Range("d:d").Find(Range("L3"))
Range("I2") = rng.Row    '14
Range("I3") = rng.Column '4
Range("I4") = rng.Value  '����

End Sub