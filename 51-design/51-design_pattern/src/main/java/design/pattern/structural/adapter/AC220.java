package design.pattern.structural.adapter;

/**
 * 被适配者 220V的交流电
 */
public class AC220 {
    public int outputAC220V() {
        int output = 220;
        System.out.println("输出交流电" + output + "V");
        return output;
    }
}
