Sub shishi()

'声明rng是Range
Dim rng As Range

For Each rng In Range("b1:b20")
      If rng.Offset(0, -1) = "男" Then
          rng = "先生"
      Else
          rng = "女士"
      End If
Next

End Sub


############################
' 使用End(xlUp)得写
'
' 判断男女
'
Sub pd()

Dim rng As Range

'For Each rng In Range("b1:b20")
' b2:b & a的边界
For Each rng In Range("b2:b" & Range("a65536").End(xlUp).Row)
      If rng.Offset(0, -1) = "男" Then
          rng = "先生"
      Else
          rng = "女士"
      End If
Next

End Sub

############################
'
' 边界
'

Sub shishi2()

Range("a65536").End(xlUp).Select

End Sub

############################
Sub shishi3()

Range("a1").Resize(1, 4).Select

End Sub

############################
Sub delRow()

Range("a1").EntireRow.Delete  '整行删除Row

End Sub


############################
Sub copyRow()

Range("a7").EntireRow.Copy Range("a30")  

Range("h7:l7").Copy Range("n7")
Range("a7").Copy Range("a23")

End Sub


############################
'
' 合并单元格
'
Sub merge()

Dim rng As Range

For Each rng In Range("h21:o21")
    
    rng.Resize(2, 1).merge
    
Next

End Sub
