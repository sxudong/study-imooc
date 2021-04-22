# 18 第十八课 VBA字典与用户界面设计
## 1）使用VBA字典 去重复值 （跟JAVA的HashMap一样）

配置数字典：
VBAProject -> 工具 -> 引用 -> 浏览 -> 找到"scrrun.dll" 
-> 打开-> 勾选"Microsoft Forms 2.0 Object Library"

```vb
Dic(“张三”) = 3000  'Dic(“key”) = value
DIC.KEYS
```

## 2）创建三级下拉列表

  - 使用LISTBOX对象
      可以设置几列和列宽
  - 查找不重复值输入拉框

## 3）销售界面中的控件逻辑

判断哪些控件会相互影响

DEMO-1-字典.xlsm

