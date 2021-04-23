package chap2.Arrays.example6.GenericDataStructures;

public class Student {

    private String name;
    private int score;

    public Student(String studentName, int studentScore){
        name = studentName;
        score = studentScore;
    }

    @Override
    public String toString(){
        return String.format("Student(name: %s, score: %d)", name, score);
    }

    public static void main(String[] args) {

        Array<Student> arr = new Array<>();
        arr.addLast(new Student("Alice", 100));
        arr.addLast(new Student("Bob", 66));
        arr.addLast(new Student("Charlie", 88));
        System.out.println(arr);
    }
    /* Output:
      Array: size = 3 , capacity = 10
      [Student(name: Alice, score: 100), Student(name: Bob, score: 66), Student(name: Charlie, score: 88)]
     */
}
