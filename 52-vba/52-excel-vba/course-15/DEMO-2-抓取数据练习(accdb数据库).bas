'使用前请确认是否勾选了Microsoft ActiveX Data Object  x.x  Library！！！
Sub test()
    Dim conn As New ADODB.Connection
    Dim sql As String
    '注意这个链接文件的路径！！！需要把Adata文件放入d:\data文件夹！！

    Range("a2:z1000").ClearContents
    'conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\Adata.accdb"
    conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\15第十五课\data\Adata.accdb"

    sql = "select 客户ID,公司名称,日期,产品类别,数量,金额,成本 from [客户信息表] left join [交易记录] on [客户信息表].ID=[交易记录].客户ID"

    Range("a2").CopyFromRecordset conn.Execute(sql)

    conn.Close
End Sub


'==================================================
'查询客户信息表
'
Sub test2()
    Dim conn As New ADODB.Connection
    Dim sql As String

    Range("a2:z1000").ClearContents
    'conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\Adata.accdb"
    conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\15第十五课\data\Adata.accdb"

    sql = "select * from [客户信息表]"

    Range("a2").CopyFromRecordset conn.Execute(sql)

    conn.Close
End Sub


'==================================================
'条件查询
'
Sub test3()
    Dim conn As New ADODB.Connection
    Dim sql As String

    Range("a2:z1000").ClearContents
    'conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\Adata.accdb"
    conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\15第十五课\data\Adata.accdb"

    sql = "select * from [客户信息表] where 城市='天津'"

    Range("a2").CopyFromRecordset conn.Execute(sql)

    conn.Close
End Sub


'==================================================
'删除
'
Sub del()
    Dim conn As New ADODB.Connection
    Dim sql As String

    Range("a2:z1000").ClearContents
    'conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\Adata.accdb"
    conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=E:\视频资料\ExcelVBA\王佩丰 VBA 教程资料\王佩丰 VBA 课件\15第十五课\data\Adata.accdb"

    sql = "delete from [客户信息表]  where 公司名称='森通'"

    conn.Execute (sql)

    conn.Close
End Sub
