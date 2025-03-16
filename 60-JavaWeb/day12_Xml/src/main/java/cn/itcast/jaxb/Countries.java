package cn.itcast.jaxb;
 
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;
 
@XmlRootElement(name = "Countries")
public class Countries {
    private List<Country> countries;
 
    public List<Country> getCountries() {
        return countries;
    }
 
    @XmlElementWrapper(name = "CountryWrapper")
    @XmlElement(name = "Country")
    public void setCountries(List<Country> countries) {
        this.countries = countries;
    }
 
    @Override
    public String toString() {
        return "Countries=[" + this.getCountries() + "]";
    }
}