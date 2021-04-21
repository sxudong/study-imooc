package design.pattern.structural.bridge.exemple2.paymode.impl;

import design.pattern.structural.bridge.exemple2.paymode.PayMode;

public class MobilePayMode implements PayMode {
    @Override
    public String mode() {
        return "移动端支付";
    }
}
