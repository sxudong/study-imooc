Sub test()
    '语法：MsgBox(Prompt[,Buttons][,Title][,Helpfile,Context])

    '(1)Prompt，必需的参数，为字符串，作为显示在消息框中的消息文本。

    '(2)Buttons，可选的参数，为数值表达式的值之和，指定显示的按钮的数目及形式、使用的图标样式、缺省按钮及消息框的强制回应等，可以此定制消息框。若省略该参数，则其缺省值为0。设置值见下表。

    '(3)Title，可选的参数，表示在消息框的标题栏中所显示的文本。若省略该参数，则将应用程序名放在标题栏中。

    '(4)Helpfile，可选的参数，为字符串表达式，提供帮助文件。若有Helpfile，则必须有Context。

    '(5)Context，可选的参数，为数值表达式，提供帮助主题。若有Context，则必须有Helpfile。

    MsgBox "你还好吗？", 4 + 32, "打招呼对话框", "C:/a.chm", 0

End Sub


Sub test1()
    Dim i As Integer
    VBA.Interaction.MsgBox

    i = MsgBox("你还好吗？", 4 + 32, "打招呼对话框", "C:/a.chm", 0)

    MsgBox i  '返回值

End Sub