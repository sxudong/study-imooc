# 13 第十三课 窗体与控件
## 1）使用窗体

开发工具 -> Visual Basic -> 在VBAProject右键插入用户窗体

## 2）“窗体”UserForm的常用属性和方法&常用事件

- 窗体常用属性
   - Enabled    可用性
   - Caption   标题
   - Visible    可见性
   - ShowModal    显示模式
- 窗体常用方法
   - Show   显示
   - Hide   隐藏
- 窗体的常用事件
  - UserForm_Activate  激活事件
     例如，找开Excel时隐藏Excel程序：Application.Visible = False
  - UserForm_QueryClose  退出事件   
     例如，窗口关闭时关闭Excel程序：Application.Quit
    （DEMO-1-窗体）

## 3）“文本框”控件常用属性 TextBox

- Enabled    可用性
-   Value        返回值
-   Visible      可见性
-   PasswordChar 密码字符 // 填“*”,用“*”表示
-   TabIndex     按下Tab键时的切换顺序
    (DEMO-2-复选框控件)

## 4）复选框控件常用属性 CheckBox

- Enabled   可用性
-   Value     返回值
-   Visible   可见性

## 5）复合框控件 ComboBox（下拉框）

- 常用属性：
  - Enabled   可用性
  - Value     返回值
  - Visible   可见性
  - List  数据源列表
-  常用方法：
  - AddItem   增加一个下拉项目
  - RemoveItem   移除一个项目
  - Clear

## 6）列表框控件 ListBox

- 常用属性：
  - Enabled   可用性
  - Value     返回值
  - Visible   可见性
  - List  数据源列表
  - 列（list数量）
-  常用方法：
  - AddItem   增加一个下拉项目
  - RemoveItem   移除一个项目
  - Clear