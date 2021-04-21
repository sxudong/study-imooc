package design.pattern.structural.flyweight;

/**
 * 经理 （经理岗位员工）
 *
 * Flyweight 轻量级
 */
public class Manager implements Employee {

    private String title = "部门经理"; // 内部状态，它是不变的，不会随外部变化
    private String department;        // 部门（外部状态，外部传入）
    private String reportContent;     // 报告内容

    public Manager(String department) {
        this.department = department;
    }

    @Override
    public void report() {
        System.out.println(reportContent);
    }

    public void setReportContent(String reportContent) {
        this.reportContent = reportContent;
    }
}
