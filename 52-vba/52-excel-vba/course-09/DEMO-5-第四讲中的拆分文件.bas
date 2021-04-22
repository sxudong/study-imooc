'
'制作加载宏工具，并使用加载宏的快速访问栏工具完成另存文件。
'
' 1、选择“*.xla”的格式另存，office软件会默认选择路径，不要修改默认路径。
' 2、在开发工具 -> 加载项 -> 勾选“小佩代码库”
' 3、在Excel选项 -> 快速访问工具栏 -> 从下列位置选择命令 -> 宏 -> 添加到右侧的“自定义快速访问工具栏”中去
Sub test()
Dim sht As Worksheet

For Each sht In Sheets
    sht.Copy
    ActiveWorkbook.SaveAs Filename:="d:\tmp\" & sht.Name & ".xlsx"
    ActiveWorkbook.Close
Next

End Sub