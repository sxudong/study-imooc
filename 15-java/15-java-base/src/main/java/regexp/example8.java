package regexp;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Regular Expressions —— Matches() & find() & lookingAt() & start() & end()
 */
public class example8 {

	public static void main(String[] args) {
		//matches find lookingAt
		Pattern p = Pattern.compile("\\d{3,5}"); //模板
		String s = "123-34345-234-00"; //匹配这个字符串
		Matcher m = p.matcher(s); //匹配之后的结果放到 Matcher 里面
		p(m.matches()); //false  matches()方法根据模板匹配整个字符串
		m.reset(); //重置（把原来吃掉的字符吐出来，恢复到原来）

		// "123-34345-234-00" 它吃到“-”发现不匹配了，
		// 正则表达式引擎分析到第4个字符，它发现整个
		// 字符串已经不匹配了，它不会往回吐，接下来再
		// 匹配时它从第5个开始找。
		p(m.find());  //true  剩下："34345-234-00"
		p(m.start() + "-" + m.end()); //0-3
		p(m.find()); //true   剩下："234-00"
		p(m.start() + "-" + m.end()); //4-9
		p(m.find()); //true   剩下："00"
		p(m.start() + "-" + m.end()); //10-13
		p(m.find()); //false
		//p(m.start() + "-" + m.end()); //java.lang.IllegalStateException: No match available


		p(m.lookingAt()); //true  lookingAt()方法每次都从头开始找
//		p(m.start() + "-" + m.end());
//		p(m.find());
//		p(m.start() + "-" + m.end());
		p(m.lookingAt()); //true
		p(m.lookingAt()); //true
		p(m.lookingAt()); //true
	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
