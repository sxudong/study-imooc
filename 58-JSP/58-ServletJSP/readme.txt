单独项目引入
1）File -> Open 打开项目

2）File -> Project Structure... -> Project 配置JDK版本

3）File -> Project Structure... -> Dependencies 添加 Tomcat 依赖，并打上勾。

4）右键点击项目名，选择 Add Framework Support... -> 勾选Web Application （注意有的项目不用色迁web.xml）

在58-JSP下引入
1）File -> Open 打开项目

2）File -> Project Structure... -> 点“+”import module "ServletJSP"项目, 一直next

3）右键点击项目名，选择 Add Framework Support... -> Java EE 下勾选 Web Application （注意有的项目不用色迁web.xml）

4）File -> Project Structure... -> Dependencies -> Choose 选择 Application Server Libraries 下的 Tomcat 依赖，并打上勾。