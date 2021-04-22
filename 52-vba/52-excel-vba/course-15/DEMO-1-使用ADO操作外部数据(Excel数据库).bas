'使用前请确认是否勾选了Microsoft ActiveX Data Object  x.x  Library！！！
Sub test()
    Dim conn As New ADODB.Connection
    Dim sql As String
    '注意这个链接文件的路径！！！需要把edata文件放入d:\data文件夹！！

    Range("a2:z1000").ClearContents

    '连接Excel数据库
    'conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\Edata.xlsx;extended properties=""excel 12.0;HDR=YES"""
    conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\15第十五课 使用ADO操作外部数据\data\Edata.xlsx;extended properties=""excel 12.0;HDR=YES"""  'YES不需要表头

    '查询“data表”、“data2表”、“data3表”
    sql = "select a.姓名,年龄,性别,月薪 from (select * from [data$] union all select * from [data2$])a left join [data3$] on a.姓名=[data3$].姓名"

    'Range("a2").CopyFromRecordset conn.Execute("select * from [data$]") '抓数据从A2开始写
    Range("a2").CopyFromRecordset conn.Execute(sql)

    conn.Close
End Sub


'==================================================
'查询某个字段
'
Sub query()
    Dim conn As New ADODB.Connection
    Dim sql As String

    Range("a2:z1000").ClearContents

    '连接Excel数据库
    conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\15第十五课 使用ADO操作外部数据\data\Edata.xlsx;extended properties=""excel 12.0;HDR=YES"""  'YES不需要表头

    'sql = "select * from [data$]"
    sql = "select 姓名,年龄 from [data$]"

    Range("a2").CopyFromRecordset conn.Execute(sql)

    conn.Close
End Sub


'==================================================
'插入数据
'
Sub insert()
    Dim conn As New ADODB.Connection
    Dim sql As String

    Range("a2:z1000").ClearContents

    '连接Excel数据库
    conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\15第十五课 使用ADO操作外部数据\data\Edata.xlsx;extended properties=""excel 12.0;HDR=YES"""  'YES不需要表头

    sql = "insert into [data$] (姓名,性别,年龄) values ('AA','男',33)"


    conn.Execute (sql)

    conn.Close
End Sub


'==================================================
'修改数据
'
Sub update()
    Dim conn As New ADODB.Connection
    Dim sql As String

    Range("a2:z1000").ClearContents

    '连接Excel数据库
    conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\15第十五课 使用ADO操作外部数据\data\Edata.xlsx;extended properties=""excel 12.0;HDR=YES"""  'YES不需要表头

    sql = "update [data$] set 性别='男',年龄=16 where 姓名='张三'"


    conn.Execute (sql)

    conn.Close
End Sub


'==================================================
'合并表两张字段一样的表
'
Sub union()
    Dim conn As New ADODB.Connection
    Dim sql As String

    '连接Excel数据库
    conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\15第十五课 使用ADO操作外部数据\data\Edata.xlsx;extended properties=""excel 12.0;HDR=YES"""  'YES不需要表头

    sql = "select * from [data$] union all select * from [data2$]"

    Range("a2").CopyFromRecordset conn.Execute(sql)

    conn.Close
End Sub


'==================================================
'左右合并表
'
Sub LeftJoin()
    Dim conn As New ADODB.Connection
    Dim sql As String

    Range("a2:z1000").ClearContents

    '连接Excel数据库
    conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\15第十五课 使用ADO操作外部数据\data\Edata.xlsx;extended properties=""excel 12.0;HDR=YES"""  'YES不需要表头

    'sql = "select [data$].姓名,性别,年龄,月薪 from [data$] right join [data3$] on [data$].姓名=[data3$].姓名 " '以左边表为主
    sql = "select [data$].姓名,性别,年龄,月薪 from [data$] left join [data3$] on [data$].姓名=[data3$].姓名 "  '以右边表为主


    Range("a2").CopyFromRecordset conn.Execute(sql)

    conn.Close
End Sub
