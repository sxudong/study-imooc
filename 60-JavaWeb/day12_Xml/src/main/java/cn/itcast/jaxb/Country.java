package cn.itcast.jaxb;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;
 
@XmlType(propOrder = {"name", "capital", "population", "foundationTime"})
@XmlRootElement(name = "Country")
public class Country {
    private int population;
    private String name;
    private String capital;
    private int rank;
    private String foundationTime;
 
    public String getFoundationTime() {
        return foundationTime;
    }
 
    @XmlElement(name = "CFoundationTime")
    public void setFoundationTime(String foundationTime) {
        this.foundationTime = foundationTime;
    }
 
    public int getPopulation() {
        return population;
    }
 
    @XmlElement(name = "CPopulation")
    public void setPopulation(int population) {
        this.population = population;
    }
 
    public String getName() {
        return name;
    }
 
    @XmlElement(name = "CName")
    public void setName(String name) {
        this.name = name;
    }
 
    public String getCapital() {
        return capital;
    }
 
    @XmlElement(name = "CCapital")
    public void setCapital(String capital) {
        this.capital = capital;
    }
 
    public int getRank() {
        return rank;
    }
 
    @XmlAttribute(name = "CRank", required = true)
    public void setRank(int rank) {
        this.rank = rank;
    }
 
    @Override
    public String toString() {
        return "Country=[Name=" + this.getName() +
                ", Capital=" + this.getCapital() +
                ", Population=" + this.getPopulation() +
                ", FoundationTime=" + this.getFoundationTime() + "]";
    }
}