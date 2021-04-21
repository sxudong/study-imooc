package design.principle.dependenceinversion;

/**
 * 3-4 依赖倒置原则讲解
 */
public class Test {

    //v1
//    public static void main(String[] args) {
//        Tom tom = new Tom();
//        tom.studyJavaCourse();
//        tom.studyFECourse();
//    }

    //v2
//    public static void main(String[] args) {
//        Tom tom = new Tom();
//        tom.studyImoocCourse(new JavaCourse());
//        tom.studyImoocCourse(new FECourse());
//        tom.studyImoocCourse(new PythonCourse());
//    }

    //v3
//    public static void main(String[] args) {
//        Tom tom = new Tom(new JavaCourse());
//        tom.studyImoocCourse();
//    }
    public static void main(String[] args) {
        Tom tom = new Tom();
        tom.setiCourse(new JavaCourse());
        tom.studyImoocCourse();

        tom.setiCourse(new FECourse());
        tom.studyImoocCourse();

    }
}
/* Output:
Geely在学习Java课程
Geely在学习FE课程
 */