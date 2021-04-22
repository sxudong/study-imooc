# 06 第六课 操作单元格对象2
## 1）使用筛选功能拆分表
- 单元格自动筛选
   Sheet1.Range("A1:F1048").AutoFilter Field:=4, Criteria1:="一车间"
    Range("A1:F1048").AutoFilter // 选中筛选或取消筛选
    Field:=4 //  筛选第4列
    Criteria1:="一车间" // 筛选条件等于"一车间"

## 2）报表的合并与拆分
### 1. 建表时避免重名思路？

1. 判断是否有表与A1列重名的
2. 如果没有重名的就创建表

​       DEMO-2-建表时避免重名

### 2. Msgbox 和 Inputbox 函数

```vb
 Dim i As Integer    
 i = InputBox("你几岁啦?")
 MsgBox "哦，原来你" & i & "岁啦"
```

