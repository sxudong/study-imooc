# 添加web框架支持
右键点击项目名，选择 Add Framework Support... -> Java EE 下勾选 Web Application （注意有的项目不用web.xml）

# 添加maven框架支持
右键点击项目名，选择 Add Framework Support... -> Java EE 下勾选 Maven

# 关于webMaven项目中的jar包配置对web不起作用的问题
File -> Profect Structure(项目结构) -> Artifacts(构件) -> Available Elements(可用元素) -> 选中项目右键“Put into Output Root”
原因：配置web资源目录后直接添加构建，idea是不会把maven的依赖添加到输出目录中的，所以我们还需要将用到的jar包也放到编译结果当中，不像我们平常写的在idea控制台运行的程序，那个是不用将工具类jar包放在输出目录里的，因为idea会去项目依赖中找jar包。


# tomcat访问路径名
在 Edit Configurations -> Deployment 里的 Appliction Context 修改访问项目的名字路径