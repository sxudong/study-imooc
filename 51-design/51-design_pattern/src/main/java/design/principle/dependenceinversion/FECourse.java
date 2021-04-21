package design.principle.dependenceinversion;

/**
 * 3-4 依赖倒置原则讲解
 */
public class FECourse implements ICourse {
    @Override
    public void studyCourse() {
        System.out.println("Geely在学习FE课程");
    }

}
