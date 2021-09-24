'语法：InputBox(prompt[,title][,default][,xpos][,ypos][,helpfile,context])

'(1)Prompt 必需 字符串表达式在对话框中显示为消息?

'(2)Title 可选 对话框标题栏中显示的字符串表达式?

'(3)Default 可选 文本框中显示的字符串表达式，在未提供其他输入时作为默认响应。 如果省略了 default，文本框将显示为空。

'(4)XPos 可选 指定对话框的左边缘与屏幕的左边缘的水平距离（以缇为单位）的数值表达式。 如果省略了 xpos，对话框将水平居中。

'(5)YPos 可选 指定对话框的上边缘与屏幕的顶部的垂直距离（以缇为单位）的数值表达式。 如果省略了 ypos，对话框将位于屏幕垂直方向往下大约三分之一的位置。

'(6)Helpfile 可选 用于标识帮助文件的字符串表达式，前者用于为对话框提供上下文相关的帮助。

'(7)Context 可选 帮助上下文数值的数值表达式，该数值由帮助作者为相应的帮助主题分配。 如果提供 context，则也必须提供 helpfile。

Sub test()
Dim str

    '使用inputbox函数。VBA里有两个InputBox，一个是VBA.Interaction.MsgBox，还有一个是Application.InputBox，
    str = InputBox("请输入姓名", "登陆框", "此处输入", 100, 100, "C:/a.chm", 0)

End Sub
Sub test1()
    '使用inputbox方法
    Application.InputBox "请输入年龄", "登陆框", "此处输入", 100, 100, "C:/a.chm", 0, 1
End Sub


'################################


'类型值：
'
'0  公式
'1  数字
'2  文本（字符串）
'4  逻辑值（True  或 False）
'8  单元格引用，作为一个Range对象
'16 错误值，如 #N/A
'64 数据数组

Sub test2()
    'inputbox返回值
    Dim i As Integer
    i = Application.InputBox("请输入年龄", "登陆框", "此处输入", 100, 100, "C:/a.chm", 0, 1) '类型值指定为“1”,输入必需是数字
End Sub


'################################
Sub test3()
Dim str
    'inputbox返回值
    str = InputBox("请输入姓名", "登陆框", "在这里写")

    MsgBox str
End Sub
