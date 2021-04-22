'
'个税计算
'
Sub gs()

Dim i As Integer
For i = 2 To 12

If Range("c" & i) - 3500 <= 0 Then
    Range("d" & i) = 0
ElseIf Range("c" & i) - 3500 > 0 And Range("c" & i) - 3500 <= 1500 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.03
ElseIf Range("c" & i) - 3500 > 1500 And Range("c" & i) - 3500 <= 4500 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.1 - 105
ElseIf Range("c" & i) - 3500 > 4500 And Range("c" & i) - 3500 <= 9000 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.2 - 555
ElseIf Range("c" & i) - 3500 > 9000 And Range("c" & i) - 3500 <= 35000 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.25 - 1005
ElseIf Range("c" & i) - 3500 > 35000 And Range("c" & i) - 3500 <= 55000 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.3 - 2755
ElseIf Range("c" & i) - 3500 > 55000 And Range("c" & i) - 3500 <= 80000 Then
    Range("d" & i) = (Range("c" & i) - 3500) * 0.35 - 5505
Else
    Range("d" & i) = (Range("c" & i) - 3500) * 0.45 - 13505
End If

Next

End Sub