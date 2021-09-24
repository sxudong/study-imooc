# 15 第十五课 使用ADO操作外部数据
## 1）使用ADO连接外部Excel数据源

不打开Excel工作薄的前提下对数据进行操作，可以增加、删除、修改。用SQL语句的方式操作Excel工作薄。

 **连接步骤：**

- 1 在VBE界面中 工具—引用
      勾选Microsoft ActiveX Data Object  x.x  Library

- 2 连接代码

  ```vb
  Sub test()
  	Dim conn As New ADODB.Connection
      '这里使用SQL对数据进行操作
  	conn.Open "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\data.xlsx;extended   properties=""excel 12.0;HDR=YES"""
  	conn.Close
  End Sub
  ```

- 3 抓取数据：

   ```vb
  Range(“a1”).CopyFromRecordset conn.Execute(“select * from [data$]”）
   ```

  

## 2）常用SQL语句

 - 查询数据

   ```vb
   select * from [data$]
   ```

 - 查询某几个字段

   ```vb
   select 姓名,年龄 from [data$]
   ```

 - 带条件的查询

   ```vb
   select * from [data$] where 性别 = "男“
   ```

 - 合并两个表的数据

   ```vb
   select * from [data$] union all select * from [data2$]
   ```

 - 插入新纪录

   ```vb
   insert into [data$] (姓名,性别,年龄) values ('AA','男',33)
   ```

 - 修改一条数据

   ```vb
   update [data$] set 性别=‘男’,年龄=16 where 姓名=‘张三‘
   ```

 - 删除一条数据

   ```vb
   delete from [data$]  where 姓名='张三'
   ```

 - 使用LEFT JOIN …ON…  (类似于VLOOKUP）

    ```vb
    select [data3$].姓名,性别,年龄,月薪 from [data$] left join [data3$] on [data$].姓名=[data3$].姓名
    ```

 - 先UNION ALL 再LEFT JOIN

   ```vb
   select * from (select * from [data$] union all select * from [data2$])a left join [data3$] on a.姓名=[data3$].姓名
   ```

 - 将查询结果赋值到数组

   ```vb
   arr = Application.WorksheetFunction.Transpose(conn.Execute("select * from [data$]").GetRows)
   ```

## 3）使用ADO连接ACCESS数据库

-  1 在VBE界面中 工具—引用
      勾选Microsoft ActiveX Data Objects  x.x  Library

-  2 连接代码

  ```vb
  Sub test()
  	Dim conn As New ADODB.Connection
      '这里使用SQL对数据进行操作
  	conn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=D:\data\Adata.accdb" 
  	conn.Close
  End Sub
  ```

## 4）需要理解并记住写法的概念（其它的用时copy）
-  SELECT * FROM [data$]
- CONN.OPEN    
-  .EXECUTE   
-  .CLOSE