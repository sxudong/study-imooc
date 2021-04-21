package design.pattern.structural.decorator.section2;

/**
 * 《设计模式之禅》
 * 老爸看成绩单了
 */
public class Father {
	public static void main(String[] args) {
		//成绩单拿过来
		SchoolReport sr;
		sr = new FouthGradeSchoolReport();  //原装的成绩单
		
		//加 了最高分说明的成绩单
		sr = new HighScoreDecorator(sr);
		//又加了成绩排名的说明
		sr = new SortDecorator(sr);
		
		//看成绩单
		sr.report();
		//然后老爸，一看，很开心，就签名了
		sr.sign("老三");  //我叫小三，老爸当然叫老三
	}
}
/* Output:
这次考试语文最高是75，数学是78，自然是80
尊敬的XXX家长:
  ......
  语文 62  数学65 体育 98  自然  63
  .......
               家长签名：
我是排名第38名...
家长签名为：老三
 */