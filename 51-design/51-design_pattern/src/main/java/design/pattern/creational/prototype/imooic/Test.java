package design.pattern.creational.prototype.imooic;

/**
 * 9-2 原型模式codeing
 *
 * 所谓的原型模式就是实现的一个 Cloneable接口，实现类复制，
 * 要实现复制后属性的 Object 指向不同的地址，就要深度克隆。
 * 所谓的深度克隆就是属性值一个一个的 copy。
 */
public class Test {
    public static void main(String[] args) throws CloneNotSupportedException {
        Mail mail = new Mail();
        mail.setContent("初始化模板");

        System.out.println("初始化mail:" + mail);

        // 开启16个线程并发推送
        for (int i = 0; i < 16; i++) {
            new Thread(()->{
                for (int j = 0; j < 1000; j++) {
                    // 从基础对象中克隆出一个新的对象
                    Mail mailTemp = null;
                    try {
                        mailTemp = (Mail) mail.clone();
                        mailTemp.setName("姓名" + j);
                        mailTemp.setEmailAddress("姓名" + j + "@imooc.com");
                        mailTemp.setContent("恭喜您，此次慕课网活动中奖了");
                        MailUtil.sendMail(mailTemp);
                    } catch (CloneNotSupportedException e) {
                        e.printStackTrace();
                    }
                }
            }).start();
        }
        MailUtil.saveOriginMailRecord(mail);
    }
}
/*
clone()是从一个已有的对象中克隆出来的新对象，因此不存在线程安全问题，且会保留已有对象的所有属性，
而且因为是基于内存的直接拷贝，构造函数不会执行，性能上也会比使用new关键字直接创建会好一些。
 */