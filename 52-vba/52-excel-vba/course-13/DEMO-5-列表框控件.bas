'UserForm1 窗体对象

'激活时初始化控件
Private Sub UserForm_Activate()
    Call test2
End Sub

'#############################################

'模块

'增加列表框的选项
Sub test1()
    UserForm1.ListBox1.AddItem "苏州"
End Sub


'把单元格一列数据设置为列表框的数据源
Sub test2()
    For i = 2 To 6
        UserForm1.ListBox1.AddItem Sheet1.Range("a" & i)
    Next
End Sub


'删除掉列表框里的一项
Sub test3()
    Call test2
    UserForm1.ListBox1.RemoveItem (1) '删除第二项
End Sub


'清空列表框数据源
Sub test4()
    Call test2
    UserForm1.ListBox1.Clear
End Sub

'计算列表里有多少个选项
Sub test5()
    Call test2
    MsgBox UserForm1.ListBox1.ListCount
End Sub

'把组合框数据源里某个值输出到单元格

Sub test6()
    Call test2
    Range("c2") = UserForm1.ListBox1.List(1)
End Sub


'把下拉框里所有的选项输出到单元格区域
Sub test7()
Call test2
    Range("d1:d4") = UserForm1.ListBox1.List
End Sub