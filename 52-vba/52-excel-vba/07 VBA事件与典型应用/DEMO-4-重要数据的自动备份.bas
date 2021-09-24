' Workbook_BeforeSave事件 
'
' 点保存时会另外保存一份数据
' 在工作簿保存前,检查指定的单元格中是否包含数据。如果这些单元格中没有全部输入数据,那么不会保存该工作簿。
' 也就是说,关闭该工作簿时,不会保存对该工作簿所做的修改。
Private Sub Workbook_BeforeSave(ByVal SaveAsUI As Boolean, Cancel As Boolean)

  ThisWorkbook.SaveCopyAs "E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\07第七课 VBA事件与典型应用\完成版\data\" & Format(Now(), "yyyymmddhhmmss") & ".xls"

End Sub