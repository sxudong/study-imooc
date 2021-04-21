package design.pattern.behavioral.strategy.example;

import design.pattern.behavioral.strategy.example.log.Logger;

/**
 * https://javap.blog.csdn.net/article/details/112318399
 * 策略模式还有一种扩展实现，那就是「策略枚举」。
 * 针对上述的日志策略实现，可以优化为如下：
 */
public enum LoggerEnum implements Logger {
	CONSOLE(){
		@Override
		public void log(String s) {
			System.out.println("控制台输出日志");
		}
	},
	FILE(){
		@Override
		public void log(String s) {
			System.out.println("日志写入文件");
		}
	},
	DB(){
		@Override
		public void log(String s) {
			System.out.println("日志写入数据库");
		}
	};

	public static void main(String[] args) {
		LoggerEnum.CONSOLE.log("console");
		LoggerEnum.FILE.log("file");
		LoggerEnum.DB.log("db");
	}
}
/* Output:
控制台输出日志
日志写入文件
日志写入数据库
 */