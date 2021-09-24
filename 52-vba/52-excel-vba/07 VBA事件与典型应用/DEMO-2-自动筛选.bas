'筛选
'
Sub shaixuan()

Range("l1:q10000").ClearContents                               '复制之前先清空区域
Range("A1:F232").AutoFilter Field:=4, Criteria1:=Range("i2")   '根据单元格“i2”值进行筛选
Range("A1:F232").Copy Range("l1")                              '复制到单元格l1
Range("A1:F232").AutoFilter                                    '取消筛选

End Sub

' Workbook_Open事件
Private Sub Workbook_Open()

    MsgBox "故人西辞黄鹤楼, 烟花三月下扬州。"

End Sub

' Worksheet_Change事件
Private Sub Worksheet_Change(ByVal Target As Range)

    Application.EnableEvents = False  '临时禁止触发事件
    
    Call shaixuan  '在执行这个动作时单元格也在Change
    
    Application.EnableEvents = True   '重新启用触发事件

End Sub