package design.pattern.behavioral.visitor.example2;

import design.pattern.behavioral.visitor.example2.visitor.impl.ImagedVisitor;
import design.pattern.behavioral.visitor.example2.visitor.impl.InOutVisitor;
import design.pattern.behavioral.visitor.example2.visitor.impl.StorageVisitor;
import design.pattern.behavioral.visitor.example2.visitor.Visitor;

import java.util.ArrayList;
import java.util.List;

/**
 * 访问者模式-个性化报表
 * https://javap.blog.csdn.net/article/details/112432472
 * 场景：「档案信息化平台」
 * 希望导出的Excel内容完全不一样，简单列举如下：
 *   1.领导关心每年档案的转入、转出情况。
 *   2.影像化人员关心档案有没有被扫描成电子版，即档案有没有被影像化加工过。
 *   3.库房人员关心档案存放在哪里，希望导出档案的位置信息。
 */
public class Client {
	public static void main(String[] args) {
		List<Archive> list = build();
		System.out.println("领导需要知道档案的转入转出情况...");
		accept(list, new InOutVisitor());
		System.out.println("--------\n影像化操作员需要了解哪些档案没影像化...");
		accept(list, new ImagedVisitor());
		System.out.println("--------\n库房操作员需要知道档案放在哪里...");
		accept(list, new StorageVisitor());

	}

	static void accept(List<Archive> list, Visitor visitor){
		for (Archive archive : list) {
			archive.accept(visitor);
		}
	}

	// 模拟生成档案列表
	static List<Archive> build(){
		List<Archive> list = new ArrayList<>();
		list.add(new Archive("001","张三","男","1号库1柜1排","2020-01-01","2020-12-01",true));
		list.add(new Archive("002","李四","女","1号库1柜2排","2020-01-02","2020-12-02",false));
		list.add(new Archive("003","王五","男","1号库1柜3排","2020-01-03","2020-12-03",true));
		return list;
	}
}
/* Output:
领导需要知道档案的转入转出情况...
{档案编号:001,姓名:张三,转入日期:2020-01-01,转出日期:2020-12-01}
{档案编号:002,姓名:李四,转入日期:2020-01-02,转出日期:2020-12-02}
{档案编号:003,姓名:王五,转入日期:2020-01-03,转出日期:2020-12-03}
--------
影像化操作员需要了解哪些档案没影像化...
{档案编号:001,姓名:张三,是否影像化:true}
{档案编号:002,姓名:李四,是否影像化:false}
{档案编号:003,姓名:王五,是否影像化:true}
--------
库房操作员需要知道档案放在哪里...
{档案编号:001,姓名:张三,位置:1号库1柜1排}
{档案编号:002,姓名:李四,位置:1号库1柜2排}
{档案编号:003,姓名:王五,位置:1号库1柜3排}
 */