'觉得这个还很有用，于是简单整理了一下，高手见笑了，为了方便大家收藏，附了个WORD和EXCEL供大家下载整理。

[A65536].End(xlUp).Row                            'A列末行向上第一个有值的行数
[A1].End(xlDown).Row                               'A列首行向下第一个有值之行数
[IV1].End(xlToLeft).Column                        '第一行末列向左第一列有数值之列数。
[A1].End(xlToRight).Column                       '第一行首列向右有连续值的末列之列数
Application.CommandBars("Standard").Controls(2).BeginGroup = True '在常用工具栏的第二个按钮前插入分隔符
Cells.WrapText = False             '取消自动换行
    If Len(Target) > 5 Then           '如果当前单元格中的字符数超过5个,执行下一行
        Target.WrapText = True        '自动换行
    End If

[A1:B10].SpecialCells(xlCellTypeBlanks).Rows.Hidden = True      '有空格即隐藏行
[A2].Parent.Name                                                '返回活动单元格的工作表名
[A2].Parent.Parent.Name                                         '返回活动单元格的工作簿名


'勾选 "VBA项目的信任"
Application.SendKeys "%(tmstv){ENTER}"                 '在 Excel 窗口操作
Application.SendKeys "%(qtmstv){ENTER}"                '在 VBE 窗口操作

Application.CommandBars("命令按钮名称").Position = msoBarFloating  '使[命令按钮]悬浮在表格中
Application.CommandBars("命令按钮名称").Position = msoBarTop       '使[命令按钮]排列在工具栏中
ActiveSheet.Protect Password:="wshzw"                         '为工作表保护加口令
ActiveSheet.Unprotect Password:="wshzw"                         '解除工作表保护
ActiveSheet.ProtectContents                                 '判断工作表是否处于保护状态
Application.DisplayAlerts = False '屏蔽确认提示
ActiveCell.CurrentRegion.Select                              '选择与活动单元格相连的区域
Range("a2:a20").NumberFormatLocal = "00-00"                          '区域的格式化
ActiveSheet.Cells.SpecialCells(xlCellTypeLastCell).Row          '已用区域的最末行
ActiveSheet.Copy Before:=Sheets(1)                          '复制活动工作表到第一张工作表之前
Range("a2:a20").FormulaHidden = True                           '工作表处于保护状态时隐藏部分单元格公式
Application.AskToUpdateLinks = False                     '不询问是否更新链接,并自动更新链接
ActiveSheet.Hyperlinks.Delete                                   '删除活动工作表超链接
ActiveWorkbook.SaveLinkValues = False                        '不保存活动工作簿的外部链接值
ActiveSheet.PageSetup.CenterFooter = Range("k2").Value          '打印时设置自定义页脚
ActiveSheet.PageSetup.Orientation = xlLandscape                 '设置为横向打印
ActiveSheet.PageSetup.Orientation = xlPortrait                  '设置为纵向打印
Application.WindowState = xlMinimized    '最小化窗口
Application.WindowState = xlNormal    '最大化窗口
ActiveWorkbook.FullName                          '当前窗口文件名与路径
Application.AltStartupPath = "E:\My\MyStart"     '替补启动目录路径
Application.AutoRecover.Path                     '返回/设置Excel存储"自动恢复"临时文件的完整路径
Application.DefaultFilePath                      '选项>常规中的默认工作目录
Application.Evaluate ("=INFO(""directory"")")    '默认工作目录
Application.LibraryPath                          '返回库文件夹的路径
Application.NetworkTemplatesPath                 '返回保存模板的网络路径
Application.Path                                 '返回应用程序完整路径
Application.RecentFiles.Item(1).Path             '返回最近使用的某个文件路径,Item(1)=第一个文件
Application.StartupPath                          'Excel启动文件夹的路径
Application.TemplatesPath                        '返回模板所存储的本地路径
Application.UserLibraryPath                      '返回用户计算机上 COM 加载宏的安装路径
Debug.Print Application.PathSeparator            '路径分隔符 "\"
CurDir                                           '默认工作目录
Excel.Parent.DefaultFilePath                     '默认工作目录
ThisWorkbook.Path                                '返回当前工作薄的路径
ActiveCell.Offset(, -1).Name = "hzw"                            '定义名称
ActiveCell.Precedents.Address                                   '被当前单元格所引用的区域地址
ActiveCell.Resize(0, 2).Select                                  '选定当前单元格并向右延伸二格
ActiveSheet.AutoFilter.Range.Columns(1).SpecialCells(xlCellTypeVisible).Count -1  '显示自动筛选后的行数
Workbooks.Close  '关闭所有工作簿
Application.Quit '关闭所有工作簿

Application.ScreenUpdating = False
  ' ......
Application.ScreenUpdating = True    ' 冻结屏幕以加快程序运行

Application.EnableEvents = False
     ' ......
Application.EnableEvents = True   '抑制事件连锁执行

Application.EnableEvents = False
ActiveWorkbook.Save     '抑制BeforeSave事件的发生
Application.EnableEvents = True     '抑制指定事件

FileDateTime ("E:\My Documents\33.xls")
'或
FileDateTime (ThisWorkbook.FullName)    '文件被创建或最后修改后的日期和时间

FileLen (ThisWorkbook.FullName) / 1024
'或
FileLen ("E:\My Documents\temp\33.xls") / 1024    '文件的长度(大小),单位是 KB

Dim mm(2, 10)
Range("a1:b10") = mm            '可以将二维数组赋值给Range
Application.Dialogs(xlDialogSaveAs).Show '显示保存对话框
T = Application.GetOpenFilename("Text Files (*.dat), *.dat")    '选择文件打开路径


'如下代码可使工作簿打开后30秒(或闲置30秒)内不输入、不重新选择等,自动关闭工作簿
Private Sub Workbook_Open()               '工作簿打开事件
   tt                                     '工作簿打开时启动 tt 过程
End Sub
Private Sub Workbook_SheetChange(ByVal Sh As Object, ByVal Target As Range)  '工作表变化事件
   tt                                                                '工作表中任一单元格有变化时启动 tt 过程
End Sub
Private Sub Workbook_SheetSelectionChange(ByVal Sh As Object, ByVal Target As Range) '工作表选择变化事件
   tt                                                            '工作表中单元格的选择有变化时启动 tt 过程
End Sub

Sub tt()                                       'tt 过程
   Dim myNow As Date, BL As Integer            '定义myNow为日期型;定义BL为长整型
   myNow = Now                                 '把当前的时间赋给变量myNow
   Do                                          '开始循环语句Do
      BL = Second(Now) - Second(myNow)         '循环中不断检查变量BL的值
      If BL = 30 Then GoTo Cl                  '当BL=30即跳转到CL
      DoEvents                                 '转让控制权,以便sheets可继续操作
   Loop Until BL > 30                          '当BL>30即跳出循环
Exit Sub

Sub tt2() 
   Application.EnableEvents = False            '避免引起其他事件
   ActiveWorkbook.Close True                   '关闭活动工作簿并保存
   Application.EnableEvents = True             '可触发其他事件
End Sub
Range("e4").AddComment.Text "代头" & Chr(10) & "内容……"         '添加批注
Range("e4").Comment.Visible = True                     '显示批注


'把工作簿中所有工作表的指定列调整为最佳列宽:
Sub 调整列宽()
   Dim i%
   For i = 1 To Sheets.Count                '遍历工作簿中所有的工作表
      Sheets(i).Columns("A:K").AutoFit      '把每个工作表的[A:K]列调整为最佳列宽
   Next i
End Sub


'Do循环语句的几种形式:
'1.
Do While i > 1   '条件为True时执行
'... ...  '要执行的语句
Loop
'2.
Do Until i > 1   '条件为False时执行
'... ...  '要执行的语句
Loop
'3.
Do
'... ...  '要执行的语句
Loop While i > 1 '条件为True时执行
'4.
Do
'... ...  '要执行的语句
Loop Until i > 1 '条件为False时执行
'5.While...Wend 语句
While i > 1      '条件为True时执行
'... ...  '要执行的语句
Wend


'工作表的复制与命名
Sub wshzw()
   Dim i As Integer
   For i = 1 To 5
      Sheets("Sheet1").Copy After:=Sheets(1)  'Before/After 复制新表在 Sheets("Sheet1") 前/后
      ActiveSheet.Name = i & "月"             '为复制的新表命名
   Next i
   Sheets("Sheet1").Name = "总表"             '为 Sheets("Sheet1") 改名
End Sub

Sub 删除工作表()
    Application.DisplayAlerts = False
    Sheet1.Delete
    Application.DisplayAlerts = True
End Sub

Sub 添加工作表()
    For i = 1 To 5
        Worksheets.Add.Name = i
    Next
End Sub
[A1:A20].AdvancedFilter xlFilterCopy, [B1], Unique:=True          '可去掉重复数据
[A2:C32].Replace What:="F", Replacement:="G"                     '指定范围内的查找与替换
ActiveSheet.AutoFilterMode = False                              '取消自动筛选




'执行以下语句可有效缩小工作簿的大小，执行前请先看清每条语句的作用:
ActiveSheet.UsedRange.ClearComments             '清除活动工作表已使用范围所有批注
ActiveSheet.UsedRange.ClearFormats             '清除活动工作表已使用范围所有格式
ActiveSheet.UsedRange.Validation.Delete         '取消活动工作表已使用范围的数据有效性
ActiveSheet.Hyperlinks.Delete                   '删除活动工作表超链接
ActiveSheet.DrawingObjects.Delete               '删除活动工作表已使用范围的所有对象
ActiveSheet.UsedRange = ActiveSheet.UsedRange.Value      '取消活动工作表已使用范围的公式并保留值
还有:
Sub x()
   Dim myRange As String
   myRange = ActiveSheet.UsedRange.Address     '去除活动工作表无数据的行列
End Sub



'这相当于把新的已使用区域赋值给变量，效果等同于手工删除多余的列或行后立即保存;

'来一个函数的
Private Sub Worksheet_SelectionChange(ByVal Target As Range)
'右边单元格反向显示活动单元格文本
If ActiveCell.Column < 256 Then ActiveCell.Offset(0, 1) = StrReverse(ActiveCell)
End Sub

Sub test()
Dim myRange As String
myRange = ActiveSheet.UsedRange.Address
Debug.Print "LastRow=" & Cells.SpecialCells(xlCellTypeLastCell).Row
Debug.Print "LastColumn=" & Cells.SpecialCells(xlCellTypeLastCell).Column
myRange = ""
End Sub

'如上下相邻单元格数据相同则删除一个
Sub Yjue()
   Dim myCell As Range, NCell As Range        '定义
   Set myCell = ActiveSheet.Range("b2")       '把对象ActiveSheet.Range("b2")赋给变量myCell
   Do While Not IsEmpty(myCell)               '条件为True时执行
      Set NCell = myCell.Offset(1, 0)         '把对象myCell的下一个单元格赋给变量NCell
      If NCell.Value = myCell.Value Then      '如上下相邻单元格数据相同,则望下执行
          myCell.Delete                       '删除myCell
      End If                                  '结束条件语句
      Set myCell = NCell                      '把变量NCell赋给变量myCell,等于在循环中把原myCell下移了一格
   Loop
End Sub

'复制行高列宽与内容:
Sub Yjue()                      '过程的名称
   Sheet2.Rows("2:23").Copy     '复制行区域
   Sheet3.Select                '选择粘贴区域
   Range("A2").PasteSpecial Paste:=xlPasteColumnWidths   '粘贴类型
   ActiveSheet.Paste            '实施粘贴
   Application.CutCopyMode = False   '取消复制模式
End Sub

'如整行为空白则删除整行:

Sub DelRow()
   Dim i As Integer, LastRow As Integer
   LastRow = ActiveSheet.Cells.SpecialCells(xlCellTypeLastCell).Row  '把最后行的行号赋给变量
   For i = LastRow To 1 Step -1                                      '倒循环
      If Range("iv" & i).End(xlToLeft).Column = 1 And Range("a" & i) = "" Then
         Range("a" & i).EntireRow.Delete                          '如整行为空白则删除整行
      End If
   Next i
End Sub


'通过依次赋色给单元格的例子，展示简单的 On Error GoTo Line1 用法：
Sub Yjue()                '过程名
   Dim i As Integer       '定义 i 为整型
   On Error GoTo Line1    '遇到错误跳转到 Line1
   For i = 0 To 65        '予设从 0 循环到 65
      Cells(i + 1, 2).Interior.ColorIndex = i  '依次赋色给第2列的单元格
      Cells(i + 1, 1) = i                      '依次给第1列的单元格标上色索引号
   Next i
   Exit Sub              '退出过程
Line1:                   '遇到错误跳转到这行继续执行
   MsgBox "默认颜色只有 " & i - 1 & "种。"    '提示对话框
End Sub                  '结束过程




'通过显示或取消网格线，展示运算符“Not”应用的简单示例：
   Dim myLine As Boolean                     '定义变量myLine为布尔型
   With CommandButton1                         'With语句结构
      If .Caption = "取消网格线" Then             '如按钮上显示为"取消网格线"
         .Caption = "显示网格线"                  '改按钮上的字幕为"显示网格线"
         myLine = ActiveWindow.DisplayGridlines       '把活动窗口当前网格线的显示状态赋给变量
         ActiveWindow.DisplayGridlines = Not myLine     '进行逻辑否定运算
      Else
         .Caption = "取消网格线"                        '否则按钮上显示为"取消网格线"
         ActiveWindow.DisplayGridlines = Not myLine     '进行逻辑否定运算
      End If
   End With                           '结束With语句结构
   
   
   

'有选择地删除指定区域内的单元格，点击按钮可选择性的删除[A1：A20]区域内含有[D1]中字样的单元格；再点击按钮可返回原样；如果替换了[D1]中的字样，点击按钮后所删除[A1：A20]区域中的单元格亦会随着变化。
   With CommandButton1
      If .Caption = "删除单元格" Then       '如按钮显示的字符为:"删除单元格",
         .Caption = "反悔删除"              '则改为:"反悔删除"
         For i = 20 To 1 Step -1            '倒循环
            If Cells(i, 1) Like "*" & Range("d1") & "*" Then
               Cells(i, 1).Delete Shift:=xlUp     '如循环中发现某个单元格含有[D1]中字符,则删除该单元格
            End If
         Next i
      Else
         .Caption = "删除单元格"            '否则让按钮显示的字符为:"删除单元格"
         Range("a1:a20") = Range("f1:f20").Value   '把[F1:F20]赋给[A1:A20],为了可反复测试
      End If
   End With


'限制鼠标只能在[B2:G60]以外的区域活动的例子：

   With ActiveSheet                      'With 语句,在一个单一对象上执行一系列的语句
      .Unprotect                         '解除没设密码的工作表保护
      .Cells.Locked = False              '解除活动工作表中所有单元格的“锁定”
      .Range("b2:g60").Locked = True     '只锁定 [B2:G60] 区域
      .EnableSelection = xlUnlockedCells   '仅允许选定未被有效锁定的单元格
      .Protect                           '工作表保护(没设密码)
   End With                              'With 语句结束

'一个复制数据后，只能粘贴数值的例子

Private Sub Worksheet_SelectionChange(ByVal T As Range)  '工作表SelectionChange事件
   On Error Resume Next                                  '忽略代码运行中的错误,并越过错误继续执行后面的语句
   If T.Column = 1 Then                                '如活动单元格为第一列时执行下面的语句
      Selection.PasteSpecial Paste:=xlPasteValues     '粘贴数值
      Application.CutCopyMode = False                 '立即清空剪贴板
   End If                                            'IF结构结束
End Sub                                              '本过程结束


'如何用VBA获得工作簿名称?
For Each wbk In Workbooks
    MsgBox wbk.Name
Next
