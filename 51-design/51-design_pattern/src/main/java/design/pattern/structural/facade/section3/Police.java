package design.pattern.structural.facade.section3;

/**
 * 检查信件，比如是不是恐吓信，有没有炭疽病毒，寄往某地的邮件都要检查
 */
public class Police {
	
	//检查信件，检查完毕后警察在信封上盖个戳：此信无病毒
	public void checkLetter(ILetterProcess letterProcess){
		System.out.println(letterProcess+" 信件已经检查过了.....");
	}
}
