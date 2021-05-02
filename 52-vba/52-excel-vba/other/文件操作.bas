'建立文件夹
Function MkDir2(path)
    If Dir(path, vbDirectory) = "" Then
        MkDir path '建立文件夹
    End If
End Function

'---------------------------------------------------------------------------------------------------------
'Dir遍历单层文件夹文件
Function DirFiles(ByVal mypath, Optional ByVal fileStr = "*.*")
    '返回一个数组2列 '1 列 -纯文件名+后缀 '2 列 -完整路径
    '3 列  纯文件名
    '4列  纯后缀
    '本函数默认不搜索 隐藏文件
    If mypath Like "*\" Then '总是把传进来的路径处理成不带斜杠的数据
        mypath = Left(mypath, Len(mypath) - 1) '去掉最后的分隔符
    End If
    Dim dic
    Set dic = CreateObject("scripting.dictionary")
    Dim fname, k
    fname = Dir(mypath & "\" & fileStr)
    k = 0
    Do While fname <> "" '不为空的时候 往下循环
        k = k + 1
        If fname Like fileStr Then '实现模糊搜索文件
            '这里可以自己定义搜索条件 暂时用like方法一般就是 *匹配模糊搜索
            dic(k) = fname '写入第一个文件
        End If
        fname = Dir
    Loop
    Dim brr
    If dic.Count = 0 Then
        ReDim brr(0, 0)
    Else
        ReDim brr(1 To dic.Count, 1 To 4) '1列纯文件名 2列完整文件名
        For i = 1 To dic.Count
            brr(i, 1) = dic(i) '纯文件名
            brr(i, 2) = mypath & "\" & brr(i, 1) '完整路径+文件名
            brr(i, 3) = Left(brr(i, 1), InStrRev(brr(i, 1), ".") - 1) '纯文件名
            brr(i, 4) = Mid(brr(i, 1), InStrRev(brr(i, 1), ".") + 1) '路径
        Next
    End If
    DirFiles = brr
    '返回结果字典
End Function

'---------------------------------------------------------------------------------------------------------
'按类型选择文件
Sub 浏览指定类型的文件名称() '后面的代码自己添加
    On Error Resume Next
    Dim fileToOpen()
    fileToOpen = Application.GetOpenFilename("Excel文件 (*.xl*), *.xl*", , "请选择Excel文件", , True)
    If Err.Number > 0 Then Exit Sub
    For i = 1 To UBound(fileToOpen)
        MsgBox fileToOpen(i)
    Next i
End Sub

Public Function PickFolder()
    '** 使用FileDialog对象来选择文件夹
    Dim fd As FileDialog
    Dim strPath As String

    Set fd = Application.FileDialog(msoFileDialogFolderPicker)

    '** 显示选择文件夹对话框
    If fd.Show = -1 Then '** 用户选择了文件夹
        strPath = fd.SelectedItems(1)
    Else
        strPath = ""
    End If
    Set fd = Nothing
    PickFolder = strPath
End Function

Function PickFile(path) '打开指定目录 弹出选择文件对话框
    On Error Resume Next
    ChDrive path
    ChDir path
    PickFile = Application.GetOpenFilename("xls(*.xls;*.xlsx),*.xls;*.xlsx")
End Function

Sub Test()
    Dim i&, j&, k&, arr, brr
    Dim wbk
    Set wbk = PickFile(ThisWorkbook.path) '打开本表目录 弹出选择文件对话框
End Sub

Function OpenWbk(path) '打开指定目录 弹出选择文件对话框 返回打开的文件
    On Error Resume Next
    ChDrive path
    ChDir path
    Set OpenWbk = Workbooks.Open(Application.GetOpenFilename("xls(*.xls;*.xlsx),*.xls;*.xlsx"))
End Function
'---------------------------------------------------------------------------------------------------------
'文件对话框过滤文件类型
Sub SelectFile()
    '选择多个文件

    Dim l As Long
    With Application.FileDialog(msoFileDialogFilePicker)
        .AllowMultiSelect = True '多选择
        .Filters.Clear '清除文件过滤器
        '设置两个文件过滤器
        .Filters.Add "Excel Files", "*.xls;*.xlw"
        .Filters.Add "All Files", "*.*"
        .Show
        'FileDialog 对象的 Show 方法显示对话框，并且返回 -1（如果您按 OK）和 0（如果您按 Cancel）。
        For l = 1 To .SelectedItems.Count
            MsgBox "您选择的文件是：" & .SelectedItems(l), vbOKOnly + vbInformation, "提示："
        Next
    End With
End Sub

'---------------------------------------------------------------------------------------------------------

'FSO选择文件
Set fso = CreateObject("Scripting.FileSystemObject")
strfile = Application.InputBox("请输入文件的完整名称:", "请输入文件的完整名称:", , , , , , 2)
If fso.fileexists(strfile) Then
    MsgBox strfile & " :存在"
Else
    MsgBox strfile & " :不存在"
End If

'---------------------------------------------------------------------------------------------------------

'遍历文件夹及子文件夹搜索文件
Dim ArryFile(), nFile '全局变量 nfie初始值为0
Function searchFile(ByVal fd As Folder)
    Dim fl As File
    Dim subfd As Folder
    Dim i As Integer
    i = fd.Files.Count
    If i > 0 Then
        Set regex1 = CreateObject("VBSCRIPT.REGEXP") 'RegEx为建立正则表达式
        With regex1
            .Global = True '设置全局可用
            .Pattern = "(xls)$" '输入后缀名用|隔开"(xls|xlsx|docx|doc)$
        End With

        ReDim Preserve ArryFile(1 To nFile + i)
        For Each fl In fd.Files
            If regex1.test(fl.Name) = True Then
                nFile = nFile + 1
                ArryFile(nFile) = fl.Path
            End If
        Next
    End If

    If fd.SubFolders.Count = 0 Then Exit Function

    For Each subfd In fd.SubFolders
        searchFile subfd
    Next
End Function

'---------------------------------------------------------------------------------------------------------

'FSO单层文件遍历
Private Function FileList(Folderpath, Optional Pstr = "*", Optional Dimensions = 2)

    '遍历某文件夹下的单层文件,pstr用通配符指定筛选条件
    'Dimensions 指定是返回一维数组还是二维数组
    Dim fs, f, f1, fc, i, k, arr
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set f = fs.GetFolder(Folderpath)
    Set fc = f.Files
    ReDim arr(1 To fc.Count)
    For Each f1 In fc
        If f1.Name Like Pstr And ((f1.Attributes And 2) = 0) Then '筛选文件 排除隐藏文件
            i = i + 1
            arr(i) = f1.Name
            'arr(i, 2) = f1.Attributes
        End If
    Next

    If i = 0 Then
        ReDim Preserve arr(0 To 0)
    Else
        ReDim Preserve arr(1 To i)
    End If

    If Dimensions <> 1 And i > 0 Then
        ReDim brr(1 To i, 1 To 1)
        For k = 1 To i
            brr(k, 1) = arr(k)
        Next
        arr = brr
    End If
    FileList = arr
End Function



