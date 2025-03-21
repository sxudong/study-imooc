package design.pattern.structural.composite.other.v2;

public class Test {
    public static void main(String[] args) {
        Folder DSFolder = new Folder("设计模式资料");
        File note1 = new File("组合模式笔记.md", "组合模式组合多个对象形成树形结构以表示具有 \"整体—部分\" 关系的层次结构");
        File note2 = new File("工厂方法模式.md", "工厂方法模式定义一个用于创建对象的接口，让子类决定将哪一个类实例化。");
        DSFolder.add(note1);
        DSFolder.add(note2);

        Folder codeFolder = new Folder("样例代码");
        File readme = new File("README.md", "# 设计模式示例代码项目");
        codeFolder.add(readme);

        Folder srcFolder = new Folder("src");
        File code1 = new File("组合模式示例.java", "这是组合模式的示例代码");
        srcFolder.add(code1);

        codeFolder.add(srcFolder);
        DSFolder.add(codeFolder);

        DSFolder.print();
    }
}
/* Output:
设计模式资料
	- 组合模式笔记.md
	- 工厂方法模式.md
	- 样例代码
	- 	- README.md
	- 	- src
	- 	- 	- 组合模式示例.java
 */