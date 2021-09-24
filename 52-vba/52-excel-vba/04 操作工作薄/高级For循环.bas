'
'For循环
'
'
Sub test()

Dim i As Integer


For i = 1 To 10
    Range("a1" & i) = 1
Next


End Sub


'
'高级For循环
'
'
Sub advancedFor()

Dim ge As Range
Dim i As Integer

For Each ge In Range("a1:a10")
    
    i = i + 1
    ge = i
    
Next

End Sub