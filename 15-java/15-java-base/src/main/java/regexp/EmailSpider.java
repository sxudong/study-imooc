package regexp;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 抓取网页中的 email 地址
 */
public class EmailSpider {

	public static void main(String[] args) {
		try {
			BufferedReader br = new BufferedReader(new FileReader("G:\\IDworkspace\\study-imooc\\15-java\\15-java-base\\src\\main\\java\\regexp\\1043633.html"));
			String line = "";
			while((line=br.readLine()) != null) {
				parse(line);
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private static void parse(String line) {
		Pattern p = Pattern.compile("[\\w[.-]]+@[\\w[.-]]+\\.[\\w]+");
		Matcher m = p.matcher(line);
		while(m.find()) {
			System.out.println(m.group());
		}
	}
}
/* Output:
git@gitee.com
git@gitee.com
20git@oschina.cn
git@oschina.cn
12377@2x-1aa42ed2d2256f82a61ecf57be1ec244.png
 */