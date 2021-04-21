package design.pattern.structural.decorator.section1;

/**
 * 《设计模式之禅》
 * 老爸看成绩单了
 */
public class Father {
	
	public static void main(String[] args) {
		//成绩单拿过来
		SchoolReport sr = new FouthGradeSchoolReport();		
		//看成绩单
		sr.report();		
		//签名？休想！
	}
}
/* Output:
尊敬的XXX家长:
  ......
  语文 62  数学65 体育 98  自然  63
  .......
               家长签名：
 */
