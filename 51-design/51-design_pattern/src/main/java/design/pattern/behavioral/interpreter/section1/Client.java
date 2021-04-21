package design.pattern.behavioral.interpreter.section1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;

/**
 * 《设计模式之禅》——第27章 解析器模式
 * 客户模拟类
 */
public class Client {

    //运行四则运算
    public static void main(String[] args) throws IOException {
        String expStr = getExpStr();
        //赋值
        HashMap<String, Integer> var = getValue(expStr);

        Calculator cal = new Calculator(expStr);
        System.out.println("运算结果为：" + expStr + "=" + cal.run(var));
    }

    //获得表达式
    public static String getExpStr() throws IOException {
        System.out.print("请输入表达式：");
        return (new BufferedReader(new InputStreamReader(System.in))).readLine();
    }

    //获得值映射
    public static HashMap<String, Integer> getValue(String exprStr) throws IOException {
        HashMap<String, Integer> map = new HashMap<String, Integer>();

        //解析有几个参数要传递
        for (char ch : exprStr.toCharArray()) {
        	// 如果不等于 + 和 - ，那就是输入的变量
			// 给变量赋值并保存到map中。
            if (ch != '+' && ch != '-') {
				//解决重复参数的问题
                if (!map.containsKey(String.valueOf(ch))) {
                    System.out.print("请输入" + ch + "的值:");
                    String in = (new BufferedReader(new InputStreamReader(System.in))).readLine();
                    map.put(String.valueOf(ch), Integer.valueOf(in));
                }
            }
        }
        return map;
    }
}
/* Output:
请输入表达式：a+b-c
请输入a的值:100
请输入b的值:20
请输入c的值:40
运算结果为：a+b-c=80
 */