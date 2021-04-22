'模块1
Sub show()
    UserForm1.show
End Sub

'UserForm1 窗口对象
Dim arr()
Dim ID As String     '产品编号ID
Dim Price As Long    '单价

'==================================================
'
'激活窗体时，初始化创建数组
'
Private Sub UserForm_Activate()
    Dim dic
    
    arr = Sheet1.Range("a2:e" & Sheet1.Range("a65536").End(xlUp).Row)  '数组赋值
    Set dic = CreateObject("Scripting.Dictionary")                     '创建字典
    For i = LBound(arr) To UBound(arr)
        dic(arr(i, 2)) = 1                                             '获取B列不重复数据
    Next
    Me.ListBox1.List = dic.keys                                        '不重复数据 赋值给 列表
End Sub


'==================================================
'第一个列表框
Private Sub ListBox1_Click()
    Dim dic
    Set dic = CreateObject("Scripting.Dictionary")    '创建字典
    
    For i = LBound(arr) To UBound(arr)
        '遍历数组第2列值 = ListBox1选中的“类别”，等于才可以加进去做key
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
    Set dic = CreateObject("Scripting.Dictionary")                                 '创建字典
    
    For i = LBound(arr) To UBound(arr)
        '遍历数组第2列值 = ListBox1选中的“类别”，并且第3列的值 = Me.ListBox2选中的“品名”
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
        '遍历数组第2列值 = ListBox1选中的“类别”，并且第3列的值 = Me.ListBox2选中的“品名”，并且第4列的值 = ListBox3选中的“规格”
        If arr(i, 2) = Me.ListBox1.Value And arr(i, 3) = Me.ListBox2.Value And arr(i, 4) = Me.ListBox3.Value Then
            ID = arr(i, 1)     '第1列 产品编号
            Price = arr(i, 5)  '第5列 价格
        End If
    Next
    
    Me.Label2.Caption = Price   '价格

End Sub


'==================================================
'ListBox显示6列数据
'
'“添加”按钮  窗体ListBox属性里设置为3列
Private Sub CommandButton1_Click()

    If Me.ListBox1.Value <> "" And Me.ListBox2.Value <> "" And Me.ListBox3.Value <> "" And Me.TextBox1 > 0 Then
        Me.ListBox4.AddItem
        Me.ListBox4.List(Me.ListBox4.ListCount - 1, 0) = ID                                        '第i行的第1列  产品ID
        Me.ListBox4.List(Me.ListBox4.ListCount - 1, 1) = Me.ListBox1.Value                         '第i行的第2列  类别
        Me.ListBox4.List(Me.ListBox4.ListCount - 1, 2) = Me.ListBox2.Value                         '第i行的第3列  品名
        Me.ListBox4.List(Me.ListBox4.ListCount - 1, 3) = Me.ListBox3.Value                         '第i行的第4列  规格
        Me.ListBox4.List(Me.ListBox4.ListCount - 1, 4) = Me.TextBox1.Value                         '第i行的第5列  数量
        Me.ListBox4.List(Me.ListBox4.ListCount - 1, 5) = Me.TextBox1.Value * Me.Label2.Caption     '第i行的第6列  价格
    Else
    
    MsgBox "请正确选择商品"
    End If

End Sub


'========================= 测试 =========================
Private Sub UserForm_Activate()
    Me.ListBox1.AddItem "张三"
    Me.ListBox1.AddItem "李四"
    Me.ListBox1.AddItem "王五"
End Sub

Private Sub UserForm_Activate()
    Me.ListBox1.AddItem
    Me.ListBox1.List(0, 0) = "张三"
    Me.ListBox1.List(0, 1) = "30"
    Me.ListBox1.List(0, 2) = "男"
End Sub

 '窗体ListBox属性里设置为3列
Private Sub UserForm_Activate()

    Dim arr()
    arr = Sheet3.Range("a2:c5")
       
    For i = LBound(arr) To UBound(arr)
        Me.ListBox1.AddItem
        Me.ListBox1.List(Me.ListBox1.ListCount - 1, 0) = arr(i, 1)  '第i行的第1列
        Me.ListBox1.List(Me.ListBox1.ListCount - 1, 1) = arr(i, 2)  '第i行的第2列
        Me.ListBox1.List(Me.ListBox1.ListCount - 1, 2) = arr(i, 3)  '第i行的第3列
    Next

End Sub
