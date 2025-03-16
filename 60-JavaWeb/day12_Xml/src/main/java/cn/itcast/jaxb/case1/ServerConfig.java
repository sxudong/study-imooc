//
// ���ļ����� JavaTM Architecture for XML Binding (JAXB) ����ʵ�� v2.2.8-b130911.1802 ���ɵ�
// ����� <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// �����±���Դģʽʱ, �Դ��ļ��������޸Ķ�����ʧ��
// ����ʱ��: 2025.03.15 ʱ�� 11:08:29 PM CST 
//


package cn.itcast.jaxb.case1;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;all>
 *         &lt;element name="ServerInfo">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;attribute name="serverId" type="{http://www.w3.org/2001/XMLSchema}string" />
 *                 &lt;attribute name="protocol" type="{http://www.w3.org/2001/XMLSchema}string" />
 *                 &lt;attribute name="port" type="{http://www.w3.org/2001/XMLSchema}int" />
 *               &lt;/restriction>
 *             &lt;/complexContent>
 *           &lt;/complexType>
 *         &lt;/element>
 *         &lt;element name="BadiduInfo">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;attribute name="url" type="{http://www.w3.org/2001/XMLSchema}string" />
 *               &lt;/restriction>
 *             &lt;/complexContent>
 *           &lt;/complexType>
 *         &lt;/element>
 *       &lt;/all>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {

})
@XmlRootElement(name = "ServerConfig")
public class ServerConfig {

    @XmlElement(name = "ServerInfo", required = true)
    protected ServerConfig.ServerInfo serverInfo;
    @XmlElement(name = "BadiduInfo", required = true)
    protected ServerConfig.BadiduInfo badiduInfo;


    public ServerConfig.ServerInfo getServerInfo() {
        return serverInfo;
    }


    public void setServerInfo(ServerConfig.ServerInfo value) {
        this.serverInfo = value;
    }

    public ServerConfig.BadiduInfo getBadiduInfo() {
        return badiduInfo;
    }

    public void setBadiduInfo(ServerConfig.BadiduInfo value) {
        this.badiduInfo = value;
    }


    /**
     * 
     * <pre>
     * &lt;complexType>
     *   &lt;complexContent>
     *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *       &lt;attribute name="url" type="{http://www.w3.org/2001/XMLSchema}string" />
     *     &lt;/restriction>
     *   &lt;/complexContent>
     * &lt;/complexType>
     * </pre>
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "")
    public static class BadiduInfo {

        @XmlAttribute(name = "url")
        protected String url;

        public String getUrl() {
            return url;
        }

        public void setUrl(String value) {
            this.url = value;
        }

    }


    /**
     * <pre>
     * &lt;complexType>
     *   &lt;complexContent>
     *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *       &lt;attribute name="serverId" type="{http://www.w3.org/2001/XMLSchema}string" />
     *       &lt;attribute name="protocol" type="{http://www.w3.org/2001/XMLSchema}string" />
     *       &lt;attribute name="port" type="{http://www.w3.org/2001/XMLSchema}int" />
     *     &lt;/restriction>
     *   &lt;/complexContent>
     * &lt;/complexType>
     * </pre>
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "")
    public static class ServerInfo {

        @XmlAttribute(name = "serverId")
        protected String serverId;
        @XmlAttribute(name = "protocol")
        protected String protocol;
        @XmlAttribute(name = "port")
        protected Integer port;

        public String getServerId() {
            return serverId;
        }

        public void setServerId(String value) {
            this.serverId = value;
        }

        public String getProtocol() {
            return protocol;
        }

        public void setProtocol(String value) {
            this.protocol = value;
        }

        public Integer getPort() {
            return port;
        }

        public void setPort(Integer value) {
            this.port = value;
        }

    }

}
