'
'�ļ��ϲ�2
'
'
Sub wjhb()
Dim str As String
Dim wb As Workbook
Dim sht As Worksheet

'str = Dir("d:\data\*.xls*")
str = Dir("E:\��Ƶ����\ExcelVBA\����� VBA �̳�����\����� VBA �μ�\10��ʮ��\data2\*.xls*")

Application.ScreenUpdating = False

For i = 1 To 100
    'Set wb = Workbooks.Open("d:\data\" & str)
    Set wb = Workbooks.Open("E:\��Ƶ����\ExcelVBA\����� VBA �̳�����\����� VBA �μ�\10��ʮ��\data2\" & str)
    
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
