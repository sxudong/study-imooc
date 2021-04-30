package regexp;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Regular Expressions —— 量词
 *
 * greedy quantifiers 贪婪量词
 * 		X? X，一次或一次也没有
 * 		X* X，零次或多次
 * 		X+ X，一次或多次
 * 		X{n} X，恰好 n 次
 *		X{n,} X，至少 n 次
 * 		X{n,m} X，至少 n 次，但是不超过 m 次
 *
 *
 * Reluctant 不情愿的量词
 * 		X?? X，一次或一次也没有
 * 		X*? X，零次或多次
 * 		X+? X，一次或多次
 * 		X{n}? X，恰好 n 次
 * 		X{n,}? X，至少 n 次
 * 		X{n,m}? X，至少 n 次，但是不超过 m 次
 *
 * Possessive 占有量词
 * 		X?+ X，一次或一次也没有
 * 		X*+ X，零次或多次
 * 		X++ X，一次或多次
 * 		X{n}+ X，恰好 n 次
 * 		X{n,}+ X，至少 n 次
 * 		X{n,m}+ X，至少 n 次，但是不超过 m 次
 */
public class example11 {
	public static void main(String[] args) {
		// Greedy quantifiers 贪婪量词
		// greedy当它看到{3，10}，最大是10、那它二话不说先吞进10个字符，再和整个表达
		// 式做匹配，能匹配得上吗？匹配不上，吐进去10个字节只是匹配了{3，10}，最后是
		// 字母，没有！这时怎么办呢？它往外吐一个和数字匹配，到止已经找到了，找到的是
		// 从0到10。
		Pattern p = Pattern.compile("(.{3,10})[0-9]"); //0-10  为了方便这里加了一个组括号，去掉效果一样
		String s = "aaaa5bbbb6";
		Matcher m = p.matcher(s);
		if(m.find())
			p(m.start() + "-" + m.end()); //0-11
		else
			p("not match!");

		// Reluctant quantifiers 不情愿的量词
		// reluctant当它看到{3.10}，一上来吃最少的，吃最少的3个字符，再和整个
		// 表达式做匹配,后面那个是数字吗?不是数字，再往里面吞一个， 吞一个之后
		// 后面那个是数字了吗?是数字了。不好意思到此为止。
		Pattern p2 = Pattern.compile("(.{3,10}?)[0-9]"); //0-5
		String s2 = "aaaa5bbbb6";
		Matcher m2 = p2.matcher(s);
		if(m2.find())
			p(m2.start() + "-" + m2.end()); //0-11
		else
			p("not match!");


		//总结：greedy 不加问号，reluctant 加问号
		//一般情况下使用的都是 greedy


		// Possessive quantifiers 独占量词 用得非常少
		// Possessive当它看到{3.10}、最大是10，它一下10个字符吃进去，它不往外吐。
		// 不往外吐,最后一个都没有了，没有了你能匹配得上吗?匹配不上了。
		Pattern p5 = Pattern.compile("(.{3,10}+)[0-9]"); //0-5
		String s5 = "aaaa5bbbb6";
		Matcher m5 = p5.matcher(s5);
		if(m5.find())
			p(m5.start() + "-" + m5.end());
		else
			p("not match!"); //not match!



	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
