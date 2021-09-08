package test3;

import java.io.FileInputStream;
import java.util.Properties;

/**
 * 测试配制文件的读取
 */
public class JDBCDemo2 {

	public static void main(String[] args) {
		try{
			//java.util.Properties
			/*
			 * Properties类用于读取properties文件
			 * 使用设该类可以以类Map的形式读取配置文件中的内容
			 *
			 * properties文件中的内容格式为类似：user=scott
			 * 那么等号左边就是key,等号右边就是value
			 */
			Properties prop = new Properties();

			/*
			 * 使用Properties去读取配置文件
			 */
			FileInputStream fis = new FileInputStream(
					"./src/main/java/config.properties");
			/*
			 * 当通过Properties读取文件后，那么这个
			 * 流依然保持打开状态，我们应当自行关闭。
			 */
			prop.load(fis);
			fis.close();
			System.out.println("成功加载配制文件");
			/*
			 * 当加载完毕后，就可以根据文本文件中等号左面的内容(key)
			 * 来获取等号右面的内容(value)了，可以变相的把Properties
			 * 看做是一个Map
			 */
			try {
				String driver = prop.getProperty("driver").trim();
				String url = prop.getProperty("url").trim();
				String user = prop.getProperty("user").trim();
				String pwd = prop.getProperty("pwd").trim();

				System.out.println("driver: "+driver);
				System.out.println("url: "+url);
				System.out.println("user: "+user);
				System.out.println("pwd: "+pwd);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
} /* Output:
成功加载配制文件
driver: com.mysql.cj.jdbc.Driver
url: jdbc:mysql://localhost:3306/orcl?serverTimezone=UTC
user: root
pwd: root
*/