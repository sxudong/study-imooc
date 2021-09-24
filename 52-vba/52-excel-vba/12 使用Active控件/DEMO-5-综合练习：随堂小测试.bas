
'第一题
Private Sub CommandButton1_Click()
    Call xieru(1)
    Sheet2.SpinButton1.Value = 1 '虽然到第1题了，SpinButton1值其实没有重设
End Sub


'最后一题
Private Sub CommandButton2_Click()
  Call xieru(8)
  Sheet2.SpinButton1.Value = 8 '虽然到第8题了，SpinButton1值其实没有重设
End Sub

'
Private Sub CommandButton3_Click()
    Call chengji
End Sub


'单选按钮控件 OptionButton1 将选项A值 写入到表3 G单元格
Private Sub OptionButton1_Click()
    Sheet3.Range("g" & Sheet2.SpinButton1.Value + 1) = "A"
End Sub


'单选按钮控件 OptionButton2 将选项B值 写入到表3 G单元格
Private Sub OptionButton2_Click()
    Sheet3.Range("g" & Sheet2.SpinButton1.Value + 1) = "B"
End Sub


'单选按钮控件 OptionButton3 将选项C值 写入到表3 G单元格
Private Sub OptionButton3_Click()
Sheet3.Range("g" & Sheet2.SpinButton1.Value + 1) = "C"
End Sub

'单选按钮控件 OptionButton4 将选项D值 写入到表3 G单元格
Private Sub OptionButton4_Click()
    Sheet3.Range("g" & Sheet2.SpinButton1.Value + 1) = "D"
End Sub


'下一题按钮 写入考题
Private Sub SpinButton1_Change()
    'Call xieru 使用带参数的Sub过程
    Call xieru(Sheet2.SpinButton1.Value)
End Sub


'##############################################################
'Workbook_Open工作表打开事件
Private Sub Workbook_Open()
    Call csh
End Sub



'##############################################################

'
'引用数据
'

'Sub xieru()
'Dim i As Integer '题号
'
'使用带参数的Sub过程
'
'SpinButton1按钮点击时触发事件调用“xieru(i)”过程，并把Sheet2.SpinButton1.Value值传进来
Sub xieru(i As Integer)

i = Sheet2.SpinButton1.Value  '这个文档中没有Sheet1表，考试界面在Sheet2中

'写入数据

With Sheet2
    '清空单选按钮
    .OptionButton1.Value = False
    .OptionButton2.Value = False
    .OptionButton3.Value = False
    .OptionButton4.Value = False
    '写入题目
    .Label2.Caption = i                  '第几题
    .Label3 = Sheet3.Range("a" & i + 1)  '考题
    .Label4 = Sheet3.Range("b" & i + 1)  'A选项
    .Label5 = Sheet3.Range("c" & i + 1)  'B选项
    .Label6 = Sheet3.Range("d" & i + 1)  'C选项
    .Label7 = Sheet3.Range("e" & i + 1)  'D选项
    
    '查看是否有CD两个选项（如果Label6、Label7是空的，那么这个button隐藏）
    If .Label6.Caption = "" Then
       .OptionButton3.Visible = False '空隐藏
    Else
        .OptionButton3.Visible = True '不空显示
    End If
    
    If .Label7.Caption = "" Then
       .OptionButton4.Visible = False
    Else
        .OptionButton4.Visible = True
    End If
    
    '返回之前的答案
    If Sheet3.Range("g" & i + 1) = "A" Then      '如果单元格值是“A”OptionButton1.Value = True A被选中
        .OptionButton1.Value = True
    ElseIf Sheet3.Range("g" & i + 1) = "B" Then  '如果单元格值是“B”OptionButton2.Value = True B被选中
        .OptionButton2.Value = True
    ElseIf Sheet3.Range("g" & i + 1) = "C" Then  '如果单元格值是“C”OptionButton3.Value = True C被选中
        .OptionButton3.Value = True
    ElseIf Sheet3.Range("g" & i + 1) = "D" Then  '如果单元格值是“D”OptionButton4.Value = True D被选中
        .OptionButton4.Value = True
    End If
    
End With

End Sub

'##############################################################
Sub csh()
    '微调按钮的最大值=题目表中A列“题目内容”的数量
    Sheet2.SpinButton1.Max = Sheet3.Range("a65536").End(xlUp).Row - 1
End Sub


'##############################################################
'成绩
Sub chengji()
Dim i, k As Integer
For i = 1 To Sheet2.SpinButton1.Max
    If Sheet3.Range("g" & i + 1) = Sheet3.Range("f" & i + 1) Then
        k = k + 1
    End If
Next

MsgBox "共做对" & k & " 道题"

Sheet2.OptionButton1.Enabled = False
Sheet2.OptionButton2.Enabled = False
Sheet2.OptionButton3.Enabled = False
Sheet2.OptionButton4.Enabled = False
Sheet2.CommandButton3.Enabled = False
End Sub






