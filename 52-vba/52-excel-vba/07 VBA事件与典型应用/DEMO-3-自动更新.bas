Sub 录制宏1()
'
' 全部刷新
'

'
    ActiveWorkbook.RefreshAll
End Sub

' Worksheet_Activate表激活事件
Private Sub Worksheet_Activate()

  ActiveWorkbook.RefreshAll

End Sub