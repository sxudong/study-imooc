package design.pattern.structural.flyweight;

import java.util.HashMap;
import java.util.Map;

/**
 * 员工工厂
 * EmployeeFactory类 是生成 Manager类 的实例的工厂。它实现了共享实例的功能。
 *
 * FlyweightFactory 轻量级工厂
 * FlyweightFactory角色 是生成 Flyweight角色 的工厂。在工厂中生成 Flyweight角色 可以实现共享实例。
 */
public class EmployeeFactory {
    private static final Map<String, Employee> EMPLOYEE_MAP = new HashMap<String, Employee>();

    // 生产经理岗位员工
    public static Employee getManager(String department) {
        Manager manager = (Manager) EMPLOYEE_MAP.get(department);

        // 如果没有就new一个放进去，并返回
        if (manager == null) {
            manager = new Manager(department); // 创建一个部门经理
            System.out.println("创建部门经理:" + department);

            String reportContent = department + "部门汇报:此次报告的主要内容是......";
            manager.setReportContent(reportContent);

            System.out.println(" 创建报告:" + reportContent);
            EMPLOYEE_MAP.put(department, manager); // 保存到 map 中
        }
        return manager;
    }

}
