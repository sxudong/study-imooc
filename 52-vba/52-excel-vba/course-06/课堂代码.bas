Sub ��1()
'
' ��1 ¼�Ƶı�
'
    Selection.AutoFilter
    ActiveSheet.Range("$A$1:$F$1048").AutoFilter Field:=4, Criteria1:="һ����"
End Sub

##################################
' ɸѡ
Sub shaifen()
Dim i As Integer

'ѭ�����еı�
For i = 2 To Sheets.Count
    '���˵�4��
    Sheet1.Range("a1:f1048").AutoFilter Field:=4, Criteria1:=Sheets(i).Name
    Sheet1.Range("a1:f1048").Copy Sheets(i).Range("a1")
Next
'ȡ��ɸѡ
Sheet1.Range("a1:f1048").AutoFilter

End Sub


##################################
' �½���
Sub xinjianbiao()
Dim sht As Worksheet
Dim k As Integer

For i = 1 To 3
    k = 0
    For Each sht In Sheets
        If sht.Name = Sheet1.Range("a" & i) Then
            k = 1
        End If
    Next
       
    If k = 0 Then
        Sheets.Add after:=Sheets(Sheets.Count)
        Sheets(Sheets.Count).Name = Sheet1.Range("a" & i)
    End If

Next

End Sub


##################################
'�������

Sub chaifenshuju() '�������

Dim sht As Worksheet
Dim k, i, j As Integer
Dim irow As Integer '���˵����һ��������


irow = Sheet1.Range("a65536").End(xlUp).Row
'��ֱ�
For i = 2 To irow
    k = 0
    For Each sht In Sheets
        If sht.Name = Sheet1.Range("d" & i) Then
            k = 1
        End If
    Next
    
    If k = 0 Then
        Sheets.Add after:=Sheets(Sheets.Count)
        Sheets(Sheets.Count).Name = Sheet1.Range("d" & i)
    End If

Next
'��������

For j = 2 To Sheets.Count
    Sheet1.Range("a1:f" & irow).AutoFilter Field:=4, Criteria1:=Sheets(j).Name
    Sheet1.Range("a1:f" & irow).Copy Sheets(j).Range("a1")
Next

Sheet1.Range("a1:f" & irow).AutoFilter

End Sub












