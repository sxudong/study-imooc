'Sheet3表 按钮点击事件
Private Sub CommandButton1_Click()
    UserForm1.show
End Sub


'==================================================

'ThisWorkbook 对象打开事件
'当文件打开时，执行一次数据库查询
Private Sub Workbook_Open()

    Dim conn As New ADODB.Connection
    
    Sheet1.Range("a2:f1000").ClearContents '每次开启删除旧的信息，然后再抓取最新数据
    Sheet4.Range("a2:f1000").ClearContents '每次开启删除旧的信息，然后再抓取最新数据
    
    'conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\bak.mp3"
    'conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & ThisWorkbook.Path & "\Database1.accdb"
    conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & ThisWorkbook.Path & "\bak.mp3"
    
    Sheet1.Range("a2").CopyFromRecordset conn.Execute("select * from [产品信息]")
    Sheet4.Range("a2").CopyFromRecordset conn.Execute("select * from [销售记录]")
    conn.Close

End Sub


'=================== UserForm1 窗口对象 ==================

Dim arr()
Dim ID As String    '产品ID
Dim Price As Long   '价格

'==================================================
'删除按钮
Private Sub CommandButton2_Click()

For i = 0 To Me.ListBox4.ListCount - 1
    If Me.ListBox4.Selected(i) = True Then
        Me.Label5.Caption = Me.Label5.Caption - Me.ListBox4.List(i, 5)   '减去删除商品的价格
        Me.ListBox4.RemoveItem i                                         '删除商品
    End If
Next

End Sub


'==================================================
'结算按钮
'
'它会写入到“销售记录”
'
Private Sub CommandButton3_Click()
Dim OrderID As String               '订单ID
Dim conn As New ADODB.Connection
Dim str As String

If Me.ListBox4.ListCount > 0 Then

    OrderID = "D" & Format(VBA.Now, "yyyymmddhhmmss")
    
    '############################################### 往数据库中插数据 ####################################################
    
    'conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\bak.mp3"
    'conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & ThisWorkbook.Path & "\Database1.accdb"
    conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & ThisWorkbook.Path & "\bak.mp3"
    
    For i = 0 To Me.ListBox4.ListCount - 1
    
        str = " ('" & OrderID & "','" & Date & "','" & Me.ListBox4.List(i, 0) & "'," & Me.ListBox4.List(i, 4) & "," & Me.ListBox4.List(i, 5) & ")"
        
        conn.Execute ("insert into [销售记录] (订单号,日期,产品编号,数量,金额) values" & str)
    Next
    
    conn.Close
    
    '######################################################################################################################
    
    MsgBox "结算成功"
    Unload Me         '关闭窗口
	Else
		MsgBox "购物清单为空"
	End If

End Sub


'==================================================
'添加按钮  窗体ListBox属性里设置为3列
Private Sub CommandButton1_Click()

	If Me.ListBox1.Value <> "" And Me.ListBox2.Value <> "" And Me.ListBox3.Value <> "" And Me.TextBox1 > 0 Then
		Me.ListBox4.AddItem
		Me.ListBox4.List(Me.ListBox4.ListCount - 1, 0) = ID                                        '第i行的第1列  产品ID
		Me.ListBox4.List(Me.ListBox4.ListCount - 1, 1) = Me.ListBox1.Value                         '第i行的第2列  类别
		Me.ListBox4.List(Me.ListBox4.ListCount - 1, 2) = Me.ListBox2.Value                         '第i行的第3列  品名
		Me.ListBox4.List(Me.ListBox4.ListCount - 1, 3) = Me.ListBox3.Value                         '第i行的第4列  规格
		Me.ListBox4.List(Me.ListBox4.ListCount - 1, 4) = Me.TextBox1.Value                         '第i行的第5列  数量
		Me.ListBox4.List(Me.ListBox4.ListCount - 1, 5) = Me.TextBox1.Value * Me.Label2.Caption     '第i行的第6列  商品总价格 = 数量 x 单价
	Else

	MsgBox "请正确选择商品"
	End If

	'商品总价  = 商品总价 + 新增商品总价
	Me.Label5.Caption = Me.Label5.Caption + Me.TextBox1.Value * Me.Label2.Caption

End Sub


'==================================================

'第一个列表框
Private Sub ListBox1_Click()
    Dim dic
    Set dic = CreateObject("Scripting.Dictionary")    '创建字典
    Me.ListBox2.Clear                                 '先清空，再往 ListBox2 写记录
    
    For i = LBound(arr) To UBound(arr)
        If arr(i, 2) = Me.ListBox1.Value Then         '获取等于“列表一”值的 C列值
            dic(arr(i, 3)) = 1                        '获取C列不重复数据
        End If
    Next
    
    Me.ListBox2.List = dic.keys   '不重复数据 赋值给 列表
    Me.ListBox3.Clear             '选择第一个列表框时，第三个列表框不需要显示数据，清空第三个列表框数据
    Me.Label2.Caption = 0         '价格规零

End Sub


'==================================================
'第二个列表框
Private Sub ListBox2_Click()
    Dim dic
    
    Me.ListBox3.Clear                                                              '先清空，再往 ListBox3 写记录
    Set dic = CreateObject("Scripting.Dictionary")                                 '创建字典
    
    For i = LBound(arr) To UBound(arr)
        If arr(i, 2) = Me.ListBox1.Value And arr(i, 3) = Me.ListBox2.Value Then    '获取等于“列表二”值的 D列值
            dic(arr(i, 4)) = 1                                                     '获取D列不重复数据
        End If
    Next
    
    Me.ListBox3.List = dic.keys                                                    '不重复数据 赋值给 列表
    Me.Label2.Caption = 0

End Sub


'==================================================
'第三个列表框
Private Sub ListBox3_Click()

    For i = LBound(arr) To UBound(arr)
        '选中的这一行数据：第i行2列 第i行3列 第i行4列
        If arr(i, 2) = Me.ListBox1.Value And arr(i, 3) = Me.ListBox2.Value And arr(i, 4) = Me.ListBox3.Value Then
            ID = arr(i, 1)     '第1列 产品编号
            Price = arr(i, 5)  '第5列 价格
        End If
    Next
    
    Me.Label2.Caption = Price   '价格

End Sub


'==================================================
'激活窗体时
Private Sub UserForm_Activate()
    Dim dic
    arr = Sheet1.Range("b2:f" & Sheet1.Range("a65536").End(xlUp).Row)  '数组赋值
    Set dic = CreateObject("Scripting.Dictionary")                     '创建字典
    For i = LBound(arr) To UBound(arr)
        dic(arr(i, 2)) = 1                                             '获取B列不重复数据
    Next
    Me.ListBox1.List = dic.keys                                        '不重复数据 赋值给 列表
End Sub



'======================== 模块1 ==========================
Sub show()

    UserForm1.show

End Sub


'==================================================
Sub test()

    Range("J1") = "D" & Format(VBA.Now, "yyyymmddhhmmss")

End Sub


'==================================================
'测试查询数据
Sub test1()

    Dim conn As New ADODB.Connection
    
    Range("p1") = ThisWorkbook.Path
    
    'conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\19第十九课 EXCEL +Access系统开发\完成版\Database1.accdb"
    conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & ThisWorkbook.Path & "\Database1.accdb"
    
    Range("a1").CopyFromRecordset conn.Execute("select * from [产品信息]")
    
    conn.Close

End Sub


'==================================================
'测试插入数据
Sub test2()

    Dim conn As New ADODB.Connection
    Dim sql As String
    
    Range("p1") = ThisWorkbook.Path
    
    conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & ThisWorkbook.Path & "\Database1.accdb"
    
    sql = "insert into [销售记录] (订单号,日期,产品编号,数量,金额) values('D2525552','2020/04/04','I45656',2,300)"
    
    conn.Execute (sql)
    
    conn.Close

End Sub

