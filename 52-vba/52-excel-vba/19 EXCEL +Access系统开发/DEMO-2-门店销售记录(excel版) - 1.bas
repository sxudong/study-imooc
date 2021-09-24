'Sheet3表 按钮点击事件
Private Sub CommandButton1_Click()
    UserForm1.show
End Sub


'=================== UserForm1 窗口对象 ==================

Dim arr()
Dim ID As String    '产品ID
Dim Price As Long   '价格

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
'它会写入到“销售记录”表
Private Sub CommandButton3_Click()
Dim OrderID As String
Dim i

If Me.ListBox4.ListCount > 0 Then

    i = Sheet2.Range("a65536").End(xlUp).Row + 1
    OrderID = "D" & Format(VBA.Now, "yyyymmddhhmmss")  '订单ID
    
    '多条数据
    For j = 0 To Me.ListBox4.ListCount - 1
        Sheet2.Range("a" & i) = OrderID
        Sheet2.Range("b" & i) = Date
        Sheet2.Range("c" & i) = Me.ListBox4.List(j, 0)
        Sheet2.Range("d" & i) = Me.ListBox4.List(j, 4)
        Sheet2.Range("e" & i) = Me.ListBox4.List(j, 5)
        i = i + 1
    Next
    
    MsgBox "结算成功"
    Unload Me               '关闭窗口
    
    Else
        MsgBox "购物清单为空"      '如果结算，购物车中没有商品提示
    End If

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
    arr = Sheet1.Range("a2:e" & Sheet1.Range("a65536").End(xlUp).Row)  '数组赋值
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
    Sheet2.Range("a65536").End (xlUp)
    Range("J1") = "D" & Format(VBA.Now, "yyyymmddhhmmss")  '订单ID
End Sub
