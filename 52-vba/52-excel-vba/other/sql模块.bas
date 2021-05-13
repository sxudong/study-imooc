function sqlExcute(sql_string as string)
'sql查询语句，sql语句作为参数直接导入即可
    Dim Conn As Object, Rst As Object
    Dim strConn As String
    Dim i As Integer, PathStr As String
    Set Conn = CreateObject("ADODB.Connection")
    Set Rst = CreateObject("ADODB.Recordset")
    PathStr = ThisWorkbook.FullName   '设置工作簿的完整路径和名称
    Select Case Application.Version * 1    '设置连接字符串,根据版本创建连接
        Case Is <= 11
            strConn = "Provider=Microsoft.Jet.Oledb.4.0;Extended Properties=excel 8.0;Data source=" & PathStr
        Case Is >= 12
            strConn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & PathStr & ";Extended Properties=""Excel 12.0;HDR=YES"";"""
    End Select

    Conn.Open strConn    '打开数据库链接
    Set Rst = Conn.Execute(sql_string)    '执行查询，并将结果输出到记录集对象


    If Rst.EOF Then
        sqlExcute = False
    Else
        sqlExcute = Rst.getrows
    End If

    Rst.Close
    Conn.Close
end function



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function sqlTranspose(sql_record)
'sql数据转置，用于将sql查询到的数据集，转置成可以直接粘贴到excel单元格的格式
  Dim arr()

    If IsArray(sql_record) Then
    '获取sql数据集1,2维长度
        colx = UBound(sql_record,1)
        rowx = UBound(sql_record, 2)

        ReDim arr(0 To rowx, 0 To colx)
        '循环转置数组
        For nrow = 0 To rowx
            For ncol = 0 To colx
                arr(nrow, ncol) = sql_record(ncol, nrow)
            Next
        Next

        sqlTranspose = arr
    Else
        sqlTranspose = False
    End If

end function



'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function sqlRemoteConnectinon()
'mysql数据库远程连接功能，返回连接对象
'注意：需要安装相应的mysql驱动模块
'
    Dim cn As ADODB.Connection  '定义数据链接对象 ，保存连接数据库信息；请先添加ADO引用
    Dim rs As ADODB.Recordset '定义记录集对象，保存数据表
    Set cn = New ADODB.Connection
    Set rs = New ADODB.Recordset

    '设服务器地址、所连数据，及登录用户密码
    ser = ""  '远程数据库连接地址
    Db = ""   '数据库名称
    user = "" '数据库用户名
    pwd = ""  '数据库连接密码
    strconnt = "DRIVER={MySQL ODBC 8.0 Unicode Driver};SERVER=" & ser & ";Database=" & Db & ";Uid=" & user & ";Pwd=" & pwd
    cn.ConnectionString = strconnt
    cn.Open

    Set sqlObject = cn
End Function