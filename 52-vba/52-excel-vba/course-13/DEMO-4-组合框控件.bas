'UserForm1 窗体对象

'按钮控件
Private Sub CommandButton1_Click()
  '获取下拉框选中的值 -> 填到指定单元格中
  Sheet1.Range("b1") = Me.ComboBox1.Value
End Sub

'按钮控件
Private Sub CommandButton2_Click()
  '获取“List数据源”中的第2个值 -> 填到指定单元格中
  Sheet1.Range("b2") = Me.ComboBox1.List(1)
End Sub

'激活时初始化控件
Private Sub UserForm_Activate()
  'Call test1
  Call test2
  Me.ComboBox1.RemoveItem (2) '移除下拉框中的的第2个值
  'Me.ComboBox1.Clear '清空下拉框中的值
End Sub


'模块

'增加下拉框的选项
Sub test1()
    UserForm1.ComboBox1.AddItem "苏州"
    UserForm1.ComboBox1.AddItem "昆山"
End Sub


'把单元格一列数据设置为下拉的数据源
Sub test2()
    For i = 2 To 6
        UserForm1.ComboBox1.AddItem Sheet1.Range("a" & i)
    Next
End Sub


'删除掉下拉框里的一项
Sub test3()
    Call test2
    UserForm1.ComboBox1.RemoveItem (1) '删除第二项
End Sub


'清空下拉框数据源
Sub test4()
    Call test2
    UserForm1.ComboBox1.Clear
End Sub

'计算下拉框里有多少个选项
Sub test5()
    Call test2
    MsgBox UserForm1.ComboBox1.ListCount
End Sub

'把下拉框数据源里某个值输出到单元格

Sub test6()
    Call test2
    Range("c2") = UserForm1.ComboBox1.List(1)
End Sub


'把下拉框里所有的选项输出到单元格区域
Sub test7()
    Call test2
    Range("d1:d5") = UserForm1.ComboBox1.List
End Sub