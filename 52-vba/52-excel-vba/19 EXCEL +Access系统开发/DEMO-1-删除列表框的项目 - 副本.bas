'Sheet1 对象
'CommandButton1_Click 按钮点击事件
Private Sub CommandButton1_Click()
    Call delMenu
End Sub


'==================================================
'激活Sheet1时
'Worksheet_Activate事件
Private Sub Worksheet_Activate()
    Dim arr()
    Dim dic
    
    arr = Range("a2:e14")                           '区域赋值给数据
    Set dic = CreateObject("Scripting.Dictionary")  '创建字典
    
    For i = LBound(arr) To UBound(arr)
        dic(arr(i, 2)) = 1                          '获取B列不重复数据
    Next
    
    Me.ListBox1.List = dic.keys                     '不重复数据 赋值给 列表

End Sub


'==================================================
'删除
'
Sub delMenu()
    Dim i As Integer
    
    For i = 0 To Sheet1.ListBox1.ListCount - 1                    '表1 列表框
        If Me.ListBox1.Selected(i) Then Me.ListBox1.RemoveItem i  '如果i 行是被 Selected 选中的，那么删除
    Next

End Sub