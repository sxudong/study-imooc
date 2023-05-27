package com.payroll.paymentClassification;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Date;

/**
 * 钟点工 时间卡
 */
@Getter
@AllArgsConstructor
public class TimeCard {

    /**
     * 日期
     */
    private Date date;

    /**
     * 工作时长
     */
    private double hours;

}
