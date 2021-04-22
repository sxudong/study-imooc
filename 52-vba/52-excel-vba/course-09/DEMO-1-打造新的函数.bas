'转美金
'
'
Function zmj(x)

  zmj = x / 6.03 - x * 0.03

End Function

Sub abc()

  Range("L2") = zmj(Range("K2"))

End Sub

###################################
'
'判断性别
'
'
Function sex(str As String)

    If str = "男" Then
        sex = "先生"
    Else
        sex = "女士"
    End If
    
End Function

###################################
'
'转美金
'
Function ConvertToDollar(x)

    ConvertToDollar = x / 6.03 - x * 0.03

End Function