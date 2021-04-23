package chap14.HashTable.example7.ThirdVersion;


import java.util.Objects;

public class Info {
    //员工号
    private String key;
    //员工值
    private String value;

    public Info(String key, String value) {
        this.key = key;
        this.value = value;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
    @Override
    public String toString() {
        return "Info{" +
                "key='" + key + '\'' +
                ", value='" + value + '\'' +
                '}';
    }
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Info info = (Info) o;
        return Objects.equals(key, info.key) &&
                Objects.equals(value, info.value);
    }
}
