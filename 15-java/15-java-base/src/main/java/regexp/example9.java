package regexp;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Regular Expressions —— 替换字符串
 *         replacement()方法全部替换
 * 需求：将所有的“java”,不管大小写都替换成为大小“JAVA”
 */
public class example9 {

    public static void main(String[] args) {
        //Pattern.CASE_INSENSITIVE 忽略水小写
        Pattern p = Pattern.compile("java", Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher("java Java JAVa JaVa IloveJAVA you hateJava afasdfasdf");
        p(m.replaceAll("JAVA")); //JAVA JAVA JAVA JAVA IloveJAVA you hateJAVA afasdfasdf

        // appendReplacement()、appendTail() 这个替换字符串的方法非常的灵活，
        // 这个比replaceAll() 等等这些常用的方法要强大灵活得多。
        m.reset();
        StringBuffer buf = new StringBuffer();
        int i = 0;
        //将双数转换为小写的“java”,单数的转换为大写的“JAVA”.
        while (m.find()) {
            i++;
            if (i % 2 == 0) { //双数的转换为小写
                // 追加替换
                m.appendReplacement(buf, "java");
            } else { //单数转换为大写
                m.appendReplacement(buf, "JAVA");
            }
        }
        m.appendTail(buf); //把尾巴添加回来
        p(buf); //JAVA java JAVA java IloveJAVA you hatejava afasdfasdf
	}

    public static void p(Object o) {
        System.out.println(o);
    }

}
