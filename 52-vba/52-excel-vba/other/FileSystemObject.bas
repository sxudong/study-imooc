
Sub FolderExists(sourcename)
Set fso1 = CreateObject("Scripting.FileSystemObject")

 '判断datasource文件夹是否存在  不存在 则退出程序
If Not fso1.FolderExists(sourcename) Then
    MsgBox "在本工作簿路径下，没有找到数据源文件夹：" & sourcename
    Exit Sub
End If

Set fso1 = Nothing

End Sub

'''''''''''''''''''''''''''''''''''''''''''''''

Sub FileExists(sourcename)
Set fso1 = CreateObject("Scripting.FileSystemObject")

 '判断datasource文件夹是否存在  不存在 则退出程序
If Not fso1.FileExists(sourcename) Then
    MsgBox "在本工作簿路径下，没有找到文件：" & sourcename
    Exit Sub
End If

Set fso1 = Nothing

End Sub

'''''''''''''''''''''''''''''''''''''''''''''''

Sub DeleteFiles(sourcename As String)

Dim lastChar As String

Set fso1 = CreateObject("Scripting.FileSystemObject")
lastChar = Right(sourcename, 1)

If lastChar <> "\" Then sourcename = sourcename & "\"
    Set f = fso1.getfolder(sourcename)
    Set fd = f.Files

    For Each fi In fd
        Kill sourcename & "\" & fi.Name
    Next
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''

'比较两个字符串是否相等
Function FARR(a As String, b, de) As Boolean

Dim r As Boolean
Dim arrb
Dim i
r = False

If b = "" Then
    r = False
Else
    arrb = Split(b, de)
    For i = LBound(arrb) To UBound(arrb)
        If a = arrb(i) Then
            r = True
            Exit For
        End If
    Next
End If
FARR = r

End Function

'''''''''''''''''''''''''''''''''''''''''''''''

'
'获取文件夹路径
'
Function getFolderPath(folder As String)
    Dim path As String
    path = ThisWorkbook.path
    path = path & "\" & folder
    Call FolderExists(path)
    getFolderPath = path
End Function

'''''''''''''''''''''''''''''''''''''''''''''''

'
'获取文件名路径
'
Function getFilePath(folder As String, fileName As String)
    Dim path As String
    path = ThisWorkbook.path
    path = path & "\" & folder & "\" & fileName
    Call FileExists(path)
    getFilePath = path
End Function