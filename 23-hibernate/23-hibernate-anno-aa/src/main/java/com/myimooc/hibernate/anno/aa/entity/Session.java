package com.myimooc.hibernate.anno.aa.entity;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;


/**
 * 模拟 hibernatesession 接口
 *
 * https://blog.csdn.net/cfl20121314/article/details/42947483
 */
public class Session {
    //存放实体属性  
    private Map<String, String> columns = new HashMap<String, String>();

    //字符串数组存放实体的get方法集合  
    String methodNames[];

    //初始化实体类属性以及方法集合
    public Session() {
        //初始化实体，这里就不用读取配置文件的方式了，有点麻烦。   
        columns.put("name", "name");
        columns.put("age", "age");
        methodNames = new String[columns.size()];

    }

    /**
     * save方法，持久化对象
     *
     * @param user
     */
    public void save(Person person) {
        //strColumn代表数据库中表中的属性列。并将其连接起来。    
        String strColumn = "";
        int index = 0;
        for (String key : columns.keySet()) {
            strColumn += key + ",";
            String v = columns.get(key);
            //获得属性的get方法
            v = "get" + Character.toUpperCase(v.charAt(0)) + v.substring(1);
            methodNames[index] = v;
            index++;
        }

        strColumn = strColumn.substring(0, strColumn.length() - 1);

        //拼接参数占位符，即：(?, ?)  
        String strValue = "";
        for (int i = 0; i < columns.size(); i++)
            strValue += "?,";

        //获取字符串子串
        strValue = strValue.substring(0, strValue.length() - 1);
        String sql = "insert into " + "Person" + "(" + strColumn + ")" + " values (" + strValue + ")";
        System.out.println(sql);

        try {
            //获取连接
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/test", "root", "123456");
            //jdbcstate对象
            PreparedStatement state = (PreparedStatement) con.prepareStatement(sql);

            for (int i = 0; i < methodNames.length; i++) {
                //利用反射得到每一个方法的对象    
                Method method = person.getClass().getMethod(methodNames[i]);
                //得到他的返回类型    
                Class cla = method.getReturnType();
                //根据返回类型来设置插入数据库中的每个属性值。    
                if (cla.getName().equals("java.lang.String")) {
                    String returnValue = (String) method.invoke(person);
                    state.setString(i + 1, returnValue);
                } else if (cla.getName().equals("int")) {
                    Integer returnValue = (Integer) method.invoke(person);
                    state.setInt(i + 1, returnValue);
                }
            }

            //执行更新
            state.executeUpdate();
            state.close();
            con.close();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {
        Person p = new Person();
        p.setAge("1");
        p.setName("s2");

        Session session = new Session();
        try {
            session.save(p);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}