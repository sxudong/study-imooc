# 19 第十九课 EXCEL +Access系统开发
## 1）数据库伪装

conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & ThisWorkbook.Path & "\bak.mp3"
数据可以正常插入，要打开数据库时，改为正常格式后缀才能进去。



## 2）VBA代码加密

VBAPreject -> 工具 -> VBAPreject属性 -> 保护 -> 锁定工程 -> 勾选“查看时锁定工程” -> 输入密码



## 3）提示声明变量设置

VBAPreject -> 工具 -> 选项 -> 勾选“要求变量声明”



## 4）数据库连接代码

- Excel文件

  ```vb
  Dim conn As New ADODB.Connection
  
  conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\Edata.xlsx;extended properties=""excel 12.0;HDR=YES"""
  
  conn.Close
  ```

- ACCESS文件

  ```vb
  strConn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\Adata.accdb"
  ```

- Mysql数据库

  ```vb
  strConn = "Provider=SQLOLEDB;DataSource=" & Path & ";Initial Catolog=" & strDataName
  ```


- MSSQL数据库

  ```vb
  strConn = "Provider=MSDASQL;Driver={SQL Server};Server=" & Path & ";Database=" & strDataName
  ```

- Oracle数据库

  ```vb
  strConn = "Provider=madaora;Data Source=MyOracleDB; User Id=UserID; Password=Password"
  ```

  