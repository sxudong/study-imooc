package design.principle.demeter;

/**
 * 3-8 迪米特法则讲解
 */
public class Test {
    public static void main(String[] args) {
        Boss boss = new Boss();
        TeamLeader teamLeader = new TeamLeader();
        boss.commandCheckNumber(teamLeader);
    }
}
/* Output:
在线课程的数量是：20
 */