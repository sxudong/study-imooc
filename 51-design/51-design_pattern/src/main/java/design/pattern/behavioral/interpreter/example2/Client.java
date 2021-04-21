package design.pattern.behavioral.interpreter.example2;

import java.util.concurrent.ThreadLocalRandom;

/**
 * 解释器模式-破解算术验证码
 * https://javap.blog.csdn.net/article/details/112547437
 */
public class Client {
	public static void main(String[] args) {
		for (int i = 0; i < 5; i++) {
			new Calculator(build()).exec();
		}
	}

	// 模拟百度OCR识别出的表达式文本
	public static String build(){
		ThreadLocalRandom random = ThreadLocalRandom.current();
		StringBuilder sb = new StringBuilder();
		sb.append(random.nextInt(10));
		for (int i = 0; i < random.nextInt(3) + 1; i++) {
			sb.append(random.nextBoolean() ? "+" : "-");
			sb.append(random.nextInt(10));
		}
		return sb.toString();
	}
}
/*
(0+2-2) = 0
(8+0+5) = 13
(5+3) = 8
(8-6) = 2
(2+6-2) = 6
 */