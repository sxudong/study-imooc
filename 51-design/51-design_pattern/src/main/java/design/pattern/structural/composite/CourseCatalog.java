package design.pattern.structural.composite;

import java.util.ArrayList;
import java.util.List;

/**
 * 课程目录类（复合物）
 *
 * 使用组合模式最关键的是“叶子对象”和“组合对象”都要实现相同的接口，
 * 或者继承相同的抽象类。
 */
public class CourseCatalog extends CatalogComponent {
    private List<CatalogComponent> items = new ArrayList<CatalogComponent>();
    private String name;
    private Integer level;

    public CourseCatalog(String name, Integer level) {
        this.name = name;
        this.level = level;
    }

    /**
     * 把多个对象组成为一个对象，简化对多个对象的访问
     */
    @Override
    public void add(CatalogComponent catalogComponent) {
        items.add(catalogComponent);
    }

    @Override
    public String getName(CatalogComponent catalogComponent) {
        return this.name;
    }

    @Override
    public void remove(CatalogComponent catalogComponent) {
        items.remove(catalogComponent);
    }

    @Override
    public void print() {
        System.out.println(this.name);
        for (CatalogComponent catalogComponent : items) {
            // 根据level打印空隔
            if (this.level != null) {
                for (int i = 0; i < this.level; i++) {
                    System.out.print("  ");
                }
            }
            catalogComponent.print();
        }
    }
}
