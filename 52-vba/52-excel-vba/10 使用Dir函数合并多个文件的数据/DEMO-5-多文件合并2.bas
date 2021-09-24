'
'文件合并2
'
'
Sub wjhb()
Dim str As String
Dim wb As Workbook
Dim sht As Worksheet

'str = Dir("d:\data\*.xls*")
str = Dir("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data2\*.xls*")

Application.ScreenUpdating = False

For i = 1 To 100
    'Set wb = Workbooks.Open("d:\data\" & str)
    Set wb = Workbooks.Open("E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\10第十课\data2\" & str)
    
    For Each sht In wb.Sheets
        sht.Copy after:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count)
        ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count).Name = Split(wb.Name, ".")(0) & sht.Name
    Next
    
    wb.Close
    str = Dir
    If str = "" Then
        Exit For
    End If
Next

Application.ScreenUpdating = True

End Sub
