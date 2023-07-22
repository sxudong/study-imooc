package scrum.chapter17;

import java.util.Date;

/**
 * 《敏捷软件开发》第17章 NULL OBJECT 模式 P171
 */
public interface Employee {
	public boolean isTimeToPay(Date payDate);
	public void pay();  
	
	public static final Employee NULL =  new Employee() {
		@Override
		public boolean isTimeToPay(Date payDate) {
			return false;
		}

		@Override
		public void pay() {
		}
	};
}
