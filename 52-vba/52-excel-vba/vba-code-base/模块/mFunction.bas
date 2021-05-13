Attribute VB_Name = "mFunction"
Option Explicit


 Public Const mName As String = "大黄人的代码库"


'------------------------------
'检查路径是否存在
'------------------------------

Public Function CheckPath(mPath As String) As Boolean
        CheckPath = False
        If Dir(mPath, vbDirectory) <> "" Then CheckPath = True
End Function




' 坏消息
Public Function BadMsg(Message As String)
        MsgBox Message, vbCritical, mName
End Function

' 好消息
Public Function GoodMsg(Message As String)
        MsgBox Message, vbInformation, mName
End Function

' 坏消息
Public Function WarningMsg(Message As String, Optional NeedYesNo As Boolean = True)
        If NeedYesNo Then WarningMsg = MsgBox(Message, vbExclamation + vbYesNo, mName)
        If Not NeedYesNo Then MsgBox Message, vbExclamation, mName
End Function


'----------------------------------------------
'将Sheet中所有按钮都固定位置/随单元格变化
'----------------------------------------------
Public Function ChangeButtonPlacement(SheetName As String, Optional Fixed As Boolean = True)
        Dim Btn As Shape
        For Each Btn In ThisWorkbook.Sheets(SheetName).Shapes
                If Btn.Type = 8 Then
                        If Fixed Then Btn.Placement = xlFreeFloating
                        If Not Fixed Then Btn.Placement = xlMoveAndSize
                End If
        Next
End Function

'----------------------------------
'把数字转化为列
'----------------------------------
Public Function NumberToLetter(mNumber As Integer)
        NumberToLetter = Split(Cells(1, mNumber).Address, "$")(1)
End Function

'----------------------------------
'把列转化为数字
'----------------------------------
Public Function LetterToNumber(mLetter As String)
        LetterToNumber = Range(mLetter & "1").Column
End Function

'----------------------------------
'把Range对象转化为字符串
'----------------------------------
Public Function RangeToString(mRange As Range)
        Dim StartRow As Integer, EndRow As Integer
        Dim StartColumn As String, EndColumn As String
        StartRow = mRange.Row
        EndRow = mRange.Row + mRange.Rows.Count - 1
        StartColumn = NumberToLetter(mRange.Column)
        EndColumn = NumberToLetter(mRange.Column + mRange.Columns.Count - 1)
        If StartRow = EndRow And StartColumn = EndColumn Then
                RangeToString = StartColumn & StartRow
        Else
                RangeToString = StartColumn & StartRow & ":" & EndColumn & EndRow
        End If
End Function

'--------------------------------------------
' 统计一个字符串里有所有指定字符串
'--------------------------------------------
Public Function GetStrNum(MStr As String, SpecialStr As String)
        GetStrNum = Len(MStr) - Len(Replace(MStr, SpecialStr, ""))
End Function

'--------------------------------------------
' 获得第一个某以特定字符"_"后六位
'--------------------------------------------
'Public Function GetReconCode(ReconFileName As String)
'Dim StartNo As Integer
'GetReconCode = ""
'StartNo = InStr(ReconFileName, "_")  '_的位置
'If StartNo <> 0 Then
'        GetReconCode = Mid(ReconFileName, StartNo + 1, 6)
'End If
'End Function

'------------------------------
' 获得当前用户名
'------------------------------
'Public Function GetUserName()
'Dim a As Object
'Set a = CreateObject("Wscript.Network")
'GetUserName = LCase(a.UserName)
'End Function















''-------------------------------------------------------------------------
'' 选择文件夹（没有选择多个文件夹的方法，只有选择多个文件的方法）（添加到mFile中）
''-------------------------------------------------------------------------
'Public Function GetPath() As String
'        With Application.FileDialog(msoFileDialogFolderPicker)
'                .Title = mName
'                If .Show Then
'                     GetPath = .SelectedItems(1) & "\"
'                End If
'        End With
'End Function

''--------------------------------------------------------------
'' 通过某一列的值查找它旁边的一列的值 Find（添加到mSheet中了）
''--------------------------------------------------------------
'Public Function FindData(mSht As Worksheet, mColumn As String, mFindString As String, Optional mOffset As Integer = 1) As String
'        On Error GoTo NotFound
'        FindData = mSht.Range(mColumn & ":" & mColumn).Find(what:=mFindString).Offset(0, mOffset).Value
'        Exit Function
'NotFound:
'        FindData = "没有找到 [" & mColumn & "] 列含有 [" & mFindString & "] 的内容。"
'End Function
'
''--------------------------------------------------------------
'' 通过某一列的值填写它旁边的一列的值 Find（添加到mSheet中了）
''--------------------------------------------------------------
'Public Function SetData(mSht As Worksheet, mColumn As String, mFindString As String, mSetString As String, Optional mOffset As Integer = 1)
'        On Error GoTo NotFound
'        mSht.Range(mColumn & ":" & mColumn).Find(what:=mFindString).Offset(0, mOffset).Value = mSetString
'        Exit Function
'NotFound:
'        BadMsg "没有找到 [" & mColumn & "] 列含有 [" & mFindString & "] 的内容。"
'End Function