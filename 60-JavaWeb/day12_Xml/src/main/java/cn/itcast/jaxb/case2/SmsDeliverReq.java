package cn.itcast.jaxb.case2;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;


@XmlRootElement(name = "SMSDELIVERREQ")
public class SmsDeliverReq {
    private ReqHeader reqHeader;
    private List<SmsBody> smsBodys;
 
 
    @XmlElement(name = "REQHEADER")
    public ReqHeader getReqHeader() {
        return reqHeader;
    }
 
    public void setReqHeader(ReqHeader reqHeader) {
        this.reqHeader = reqHeader;
    }
 
    /**
     * 在 JAXB 标准中，@XmlElementWrapper 注解表示生成一个包装 XML 表示形式的包装器元素。
     * 此元素主要用于生成一个包装集合的包装器 XML 元素。因此，该注释支持两种形式的序列化。
     * @XmlElementWrapper 仅允许出现在集合属性上
     * @return
     */
    @XmlElementWrapper(name = "SMSBODYS")
    @XmlElement(name = "SMSBODY")
    public List<SmsBody> getSmsBodys() {
        return smsBodys;
    }
 
    public void setSmsBodys(List<SmsBody> smsBodys) {
        this.smsBodys = smsBodys;
    }

}