package cn.itcast.jaxb.case2;

import javax.xml.bind.annotation.XmlElement;


public class SmsBody {
    /**
     * 短信内容
     */
    private String content;
 
    /**
     * 手机号
     */
    private String sourceAddr;
    
    /**
     * 服务代码
     */
    private String destAddr;
    public String getContent() {
        return content;
    }
 
    @XmlElement(name = "CONTEXT")
    public void setContent(String content) {
        this.content = content;
    }
 
    public String getSourceAddr() {
        return sourceAddr;
    }
 
    @XmlElement(name = "SOURCEADDR")
    public void setSourceAddr(String sourceAddr) {
        this.sourceAddr = sourceAddr;
    }
 
    public String getDestAddr() {
        return destAddr;
    }
 
    @XmlElement(name="DESTADDR")
    public void setDestAddr(String destAddr) {
        this.destAddr = destAddr;
    }
}
