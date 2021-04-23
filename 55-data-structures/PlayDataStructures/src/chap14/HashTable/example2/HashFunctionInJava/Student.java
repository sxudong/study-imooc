package chap14.HashTable.example2.HashFunctionInJava;

/**
 * 14-3 Java中的 hashCode 方法
 */
public class Student {

    int grade;
    int cls;
    String firstName;
    String lastName;

    Student(int grade, int cls, String firstName, String lastName){
        this.grade = grade;
        this.cls = cls;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    @Override
    public int hashCode() {
        int B = 31; // 值可以随便写
        int hash = 0;
        // 由于不知道哈希表的大小，所以无法求余
        // 传进来不管大小写都转成小写字母
        hash = hash * B + ((Integer)grade).hashCode();
        hash = hash * B + ((Integer)cls).hashCode();
        hash = hash * B + firstName.toLowerCase().hashCode();
        hash = hash * B + lastName.toLowerCase().hashCode();
        return hash;
    }

    @Override
    public boolean equals(Object o){

        if(this == o) // 是不是同一个引用
            return true;

        if(o == null)
            return false;

        // 当前对象所对应的class是否等于o对应的class
        if(getClass() != o.getClass())
            return false;

        // 强转转换
        Student another = (Student)o;
        // 每个变量比较是否相等
        return this.grade == another.grade &&
                this.cls == another.cls &&
                this.firstName.toLowerCase().equals(another.firstName.toLowerCase()) &&
                this.lastName.toLowerCase().equals(another.lastName.toLowerCase());
    }

}
