'
'表格拆分为多个文件
'
'
Sub test()
Dim sht As Worksheet

Excel.Application.DisplayAlerts = False

'循环每张表
For Each sht In Sheets
    sht.Copy
	'把这个文件  另存出来
    ActiveWorkbook.Save Filename:="E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\04第四课\完成版\data\" & sht.Name & ".xlsx"
    '关闭文件
	ActiveWorkbook.Close
Next

Excel.Application.DisplayAlerts = True
End Sub
