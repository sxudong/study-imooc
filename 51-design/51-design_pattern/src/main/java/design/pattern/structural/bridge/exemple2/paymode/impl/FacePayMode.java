package design.pattern.structural.bridge.exemple2.paymode.impl;

import design.pattern.structural.bridge.exemple2.paymode.PayMode;

public class FacePayMode implements PayMode {
    @Override
    public String mode() {
        return "刷脸支付";
    }
}
