# hibernate-mysql-demo
基于maven构建的hibernate mysql demo。<br />
基于xml、annotation的hibernate demo：其中包含one-to-one、one-to-many、many-to-many映射关系的配置。
独立的测试用例。

https://gitee.com/weishengshui/hibernate-mysql-demo.git

内容如下：
* one-to-one: xml/annotation。
* one-to-many: xml/annotation。
* many-to-many: xml/annotation。
* many-to-many "join table extra column": annotation。中间实体有复合主键，还包含了额外的字段，比如：创建时间、创建人等。

----

### hibernate知识点

#### 理解inverse

inverse的意思是：相反、倒转；相反的、倒转的。
在hibernate xml映射配置文件里面表示由那一方维护表关系。inverse="true"表示由对方维护表关系，inverse="false"则反之。示例如下：

Member与MemberCard是一对多的关系

* 1. 关系由MemberCard维护。

Member配置。[Member.hbm.xml](http://git.oschina.net/weishengshui/hibernate-mysql-demo/blob/master/hibernate-example-xml/src/main/resources/com/hibernate/xml/entity/Member.hbm.xml)
```xml
<set name="memberCards" inverse="true" cascade="save-update" lazy="true"
  table="member_card">
	<key>
		<column name="member_id" not-null="true" />
	</key>	
	<one-to-many class="com.wss.lsl.hibernate.mysql.demo.xml.core.entity.MemberCard" />
</set>	
```

MemberCard配置。[MemberCard.hbm.xml](http://git.oschina.net/weishengshui/hibernate-mysql-demo/blob/master/hibernate-example-xml/src/main/resources/com/hibernate/xml/entity/MemberCard.hbm.xml)
```xml
<many-to-one name="member" column="member_id" not-null="true"
			class="com.wss.lsl.hibernate.mysql.demo.xml.core.entity.Member" />
```

执行如下java代码
```java
Member member = new Member();
member.setMemberName("张三");

Set<MemberCard> memberCards = new HashSet<MemberCard>();
MemberCard card1 = new MemberCard();
card1.setCardNo("1234567890");
MemberCard card2 = new MemberCard();
card2.setCardNo("1234567891");
MemberCard card3 = new MemberCard();
card3.setCardNo("1234567892");
// 由MemberCard维护关系，必须设置Member，不然插入外键时找不到member_id
card1.setMember(member);
card2.setMember(member);
card3.setMember(member);

memberCards.add(card1);
memberCards.add(card2);
memberCards.add(card3);

member.setMemberCards(memberCards);
session.save(member);
```
得到的sql输出如下：MemberCard在插入时，把外键也插入了。
```sql
Hibernate: insert into member (id, member_name) values (null, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
```

* 2. 关系由Member维护。

xml映射文件的配置大致相同，只是Member中的配置inverse="false", MemberCard中的\<many-to-one not-null="true" .. /\> not-null要设置成false。
先插入MemberCard，外键暂时为null，后期再由Member update设置MemberCard的外键，所以not-null要允许为null，不然执行不通过。
保存的java代码和上面稍有不同，MemberCard不需要设置Member了。
```java
Member member = new Member();
member.setMemberName("张三");

Set<MemberCard> memberCards = new HashSet<MemberCard>();
MemberCard card1 = new MemberCard();
card1.setCardNo("1234567890");
MemberCard card2 = new MemberCard();
card2.setCardNo("1234567891");
MemberCard card3 = new MemberCard();
card3.setCardNo("1234567892");

memberCards.add(card1);
memberCards.add(card2);
memberCards.add(card3);

member.setMemberCards(memberCards);
session.save(member);
```

得到的sql输出如下：多了几条update语句。
```sql
Hibernate: insert into member (id, member_name) values (null, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
Hibernate: update member_card set member_id=? where id=?
Hibernate: update member_card set member_id=? where id=?
Hibernate: update member_card set member_id=? where id=?
```

从一对多的关系维护中，不难看出由“多端”维护关系，效率要高。

#### 理解mappedBy

也是定义由谁维护关系，这是annotation中用到的。
假设A/B实体是关系的双方，mappedBy定义在实体A中(关系的被拥有方)，另一方B就是关系的拥有方，即维护关系的一方。

首先需要理解的是：mappedBy与注解@JoinColumn/@PrimaryKeyJoinColumn/@JoinTable是冲突的，不能同时在同一个属性上出现；因为
@JoinColumn/@PrimaryKeyJoinColumn/@JoinTable这几个注解是用于维护关系的，而mappedBy在关系维护方的对立面。
只要搞清楚了由谁维护关系，其余跟xml文件配置中的inverse差不多，可参考[理解inverse](http://git.oschina.net/weishengshui/hibernate-mysql-demo#%E7%90%86%E8%A7%A3inverse)，
或者看源码[Member](http://git.oschina.net/weishengshui/hibernate-mysql-demo/blob/master/hibernate-example-annotation/src/main/java/com/hibernate/annotation/entity/Member.java)/[MemberCard](http://git.oschina.net/weishengshui/hibernate-mysql-demo/blob/master/hibernate-example-annotation/src/main/java/com/hibernate/annotation/entity/MemberCard.java)

#### 理解cascade

* 1. cascade定义级联操作，即"操作完自己"之后下一步做什么。

在[理解inverse](http://git.oschina.net/weishengshui/hibernate-mysql-demo#%E7%90%86%E8%A7%A3inverse)中，Member与MemberCard是一对多的关系，Member级联save-update MemberCard，所以只要保存member
```java
session.save(member);
```
memberCard也跟着保存了。

* 2. 有时我们会看到这样一个级联配置：cascade="delete-orphan"。

annotation中这样配置
```java
// orphanRemoval=true级联更新删除"脱离"的子节点
@OneToMany(mappedBy = "member", orphanRemoval=true)
@Cascade({ CascadeType.SAVE_UPDATE })
private Set<MemberCard> memberCards;
```
或者
```java
// CascadeType.DELETE_ORPHAN级联更新删除"脱离"的子节点
@OneToMany(mappedBy = "member")
@Cascade({ CascadeType.SAVE_UPDATE, CascadeType.DELETE_ORPHAN })
private Set<MemberCard> memberCards;
```
比较新的版本，官方推荐使用orphanRemoval=true
```java
public enum CascadeType {
	...
	/** @deprecated use @OneToOne(orphanRemoval=true) or @OneToMany(orphanRemoval=true) */
	@Deprecated
	DELETE_ORPHAN,
	...
}
```

这是用于删除“脱离”的子节点。
```java
Member member = (Member)session.get(Member.class, 1);
member.setMemberName("张三2");
Set<MemberCard> memberCards = member.getMemberCards();
// 确认会员有3张会员卡
Assert.assertEquals(3, memberCards.size());
// 从中取出一张会员卡
MemberCard memberCard = memberCards.iterator().next();
// 把这张会员卡移除掉
member.getMemberCards().remove(memberCard);

session.update(member);
```
从上面的代码中可以看到只update一下member，在update member之后有一条delete语句，sql输出如下：
```sql
Hibernate: select member0_.id as id2_0_, member0_.member_name as member2_2_0_ from member member0_ where member0_.id=?
Hibernate: select membercard0_.member_id as member3_2_1_, membercard0_.id as id1_, membercard0_.id as id3_0_, membercard0_.card_no as card2_3_0_, membercard0_.member_id as member3_3_0_ from member_card membercard0_ where membercard0_.member_id=?
Hibernate: update member set member_name=? where id=?
Hibernate: delete from member_card where id=?
```
* 3. cascade：JPA & Hibernate annotation。

这里是很容易让人误解的地方。

JPA cascade: javax.persistence.CascadeType
```java
public enum CascadeType { 

    /** Cascade all operations */
    ALL, 

    /** Cascade persist operation */
    PERSIST, 

    /** Cascade merge operation */
    MERGE, 

    /** Cascade remove operation */
    REMOVE,

    /** Cascade refresh operation */
    REFRESH
}
```
Hibernate cascade：org.hibernate.annotations.CascadeType
```java
public enum CascadeType {
	ALL,
	PERSIST,
	MERGE,
	REMOVE,
	REFRESH,
	DELETE,
	SAVE_UPDATE,
	REPLICATE,
	/** @deprecated use @OneToOne(orphanRemoval=true) or @OneToMany(orphanRemoval=true) */
	@Deprecated
	DELETE_ORPHAN,
	LOCK,
	/** @deprecated use javax.persistence.CascadeType.DETACH */
	@Deprecated
	EVICT,
	DETACH
}
```
有时我们这样配置，这里应用的是JPA cascade
```java
@OneToMany(mappedBy = "member", fetch = FetchType.LAZY, cascade={CascadeType.PERSIST})
private Set<MemberCard> memberCards;
```
保存member,发现memberCard没有跟着保存，除非使用CascadeType.ALL，否则其他的都没有用。
```java
session.save(member);
```
sql输出
```sql
Hibernate: insert into member (id, member_name) values (null, ?)
```
但是session.persist()却可以级联保存
```java
session.persist(member);
```
sql输出
```sql
Hibernate: insert into member (id, member_name) values (null, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
```

如果我们想session.save()方法有效果，可以使用hibernate cascade：
```java
@OneToMany(mappedBy = "member", fetch = FetchType.LAZY)
@Cascade({ CascadeType.SAVE_UPDATE })
private Set<MemberCard> memberCards;
```
再试一下
```java
session.save(member);
```
sql输出
```sql
Hibernate: insert into member (id, member_name) values (null, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
Hibernate: insert into member_card (id, card_no, member_id) values (null, ?, ?)
```

从上面的实践中，大概可以知道cascade的类型粗略的对应着session的一个方法。更详细的内容可以查看hibernate源码
org.hibernate.engine.Cascade/org.hibernate.engine.CascadeStyle/org.hibernate.engine.CascadingActiona

#### cascade vs inverse(mappedBy)

cascade说明级联操作，操作完自己之后下一步做什么；inverse说明由谁来维护外键的值。

#### 参数设定的几种方式

* 1. 命名参数：冒号后面跟参数名称。

setString
```java
List<Member> members = session
    			.createQuery("from Member where memberName=:memName")
				.setString("memName", "张三").list();
```
setParameter
```java
// 自动判断参数的类型。
List<Member> members = session
        		.createQuery("from Member where memberName=:memName")
				.setParameter("memName", "张三").list();
```
setProperties
```java
// pojo bean
Member member = new Member();
member.setMemberName("张三");
List<Member> members = session
            	.createQuery("from Member where memberName=:memberName")
				.setProperties(member).list();

// 还有一种方式Map。
// Map<String, Object> params = new HashMap<String, Object>();
// params.put("memName", "张三");
// List<Member> members = session
//                .createQuery("from Member where memberName=:memName")
//				.setProperties(params).list();
```

* 2. 位置参数：基数位置从0开始。

原始JDBC中的java.sql.PreparedStatement 中的参数位置从1开始。和命名参数不同的是：命名参数可以出现多次(一个参数值可以复用)，比如
memberName1=:memName and memberName2=:memName。
```java
List<Member> members = session
        		.createQuery("from Member where memberName=?")
				.setString(0, "张三").list();
```

#### session.clear()

session维护着自己的一个局部缓存，我们一般称之为一级缓存。hibernate二级缓存是面向整个应用的全局缓存，整个系统共用一个缓存。

clear()方法就是清空session的缓存。
```java
tx = session.beginTransaction();
Member member = new Member();
member.setMemberName("张三");
session.save(member);
tx.commit();

tx = session.beginTransaction();
session.clear();
Member member2 = (Member)session.get(Member.class, 1);
// member2是因为查询重新创建的对象。
Assert.assertFalse(member2 == member);
tx.commit();
```
sql输出如下
```sql
Hibernate: insert into member (id, member_name) values (null, ?)
Hibernate: select member0_.id as id2_0_, member0_.member_name as member2_2_0_ from member member0_ where member0_.id=?
```
如果我们把session.clear();注视掉，将会只看到一条insert语句。
```java
tx = session.beginTransaction();
Member member = new Member();
member.setMemberName("张三");
session.save(member);
tx.commit();

tx = session.beginTransaction();
// session.clear();
Member member2 = (Member)session.get(Member.class, 1);
// member2是从缓存中取出的同一个member对象。
Assert.assertTrue(member2 == member);
tx.commit();
```

缓存只针对id的查询有效(不产生select)，下面的java代码将只输出一条insert语句。
```java
tx = session.beginTransaction();
Member member = new Member();
member.setMemberName("张三");
session.save(member);
tx.commit();

tx = session.beginTransaction();
// session.clear();
List<Member> members = session.createQuery("from Member where id=1").list();
Member member2 = members.get(0);
// 确定两个引用指向的是同一个对象
Assert.assertTrue(member2 == member);
tx.commit();
```
而如果根据其它属性查询，还是会产生一条select sql语句；但是取出的对象和之前的对象还是同一个对象，说明还是会根据查询得到的对象的
id从缓存中取，而不是重新创建对象。
```java
tx = session.beginTransaction();
Member member = new Member();
member.setMemberName("张三");
session.save(member);
tx.commit();

tx = session.beginTransaction();
// session.clear();
List<Member> members = session.createQuery("from Member where memberName='张三'").list();
Member member2 = members.get(0);
// 确定两个引用指向的是同一个对象
Assert.assertTrue(member2 == member);
tx.commit();
```

#### session.flush()

flush()方法强制数据库和缓存同步。
如果没有手工flush()，hibernate会根据session.getFlushMode()决定何时同步，默认是FlushMode.AUTO，更多内容参考
[FlushMode API](http://docs.jboss.org/hibernate/orm/3.6/javadocs/org/hibernate/FlushMode.html)。

如果调用了session.flush()，将产生两条update语句；而如果注释掉session.flush()，就只有一条update语句。
```java
tx = session.beginTransaction();
// 原来的memberName是“张三”
member = (Member)session.get(Member.class, 1);
member.setMemberName("张三2");
session.flush();
member.setMemberName("张三3");
session.update(member);
tx.commit();
```
sql输出
```sql
Hibernate: select member0_.id as id2_0_, member0_.member_name as member2_2_0_ from member member0_ where member0_.id=?
Hibernate: update member set member_name=? where id=?
Hibernate: update member set member_name=? where id=?
```

更多内容可参考[hibernate 教程](http://www.mkyong.com/tutorials/hibernate-tutorials/)

----

### 共用的依赖配置在parent pom.xml文件里面，所有子模块都可以“继承”到，不需要重复配置。
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>

	<groupId>com.wss.lsl.hibernate.mysql.demo</groupId>
	<artifactId>hibernate-mysql-demo</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<packaging>pom</packaging>
	<name>hibernate-mysql-demo</name>
	<url>http://maven.apache.org</url>

	<modules>
		<module>hibernate-example-xml</module>
		<module>hibernate-example-annotation</module>
	</modules>

	<repositories>
		<repository>
			<id>JBoss repository</id>
			<url>http://repository.jboss.com/maven2/</url>
		</repository>
	</repositories>

	<properties>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<hibernate-version>3.6.3.Final</hibernate-version>
		<hibernate-c3p0-version>3.6.3.Final</hibernate-c3p0-version>
	</properties>

	<dependencies>
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<version>3.8.1</version>
			<scope>test</scope>
		</dependency>

		<!-- h2 database -->
		<dependency>
			<groupId>com.h2database</groupId>
			<artifactId>h2</artifactId>
			<version>1.4.184</version>
			<scope>test</scope>
		</dependency>

		<!-- MYSQL Database Driver -->
		<dependency>
			<groupId>mysql</groupId>
			<artifactId>mysql-connector-java</artifactId>
			<version>5.1.9</version>
			<scope>runtime</scope>
		</dependency>

		<!-- Hibernate framework -->
		<dependency>
			<groupId>org.hibernate</groupId>
			<artifactId>hibernate-core</artifactId>
			<version>${hibernate-version}</version>
		</dependency>

		<!-- hibernate library dependency -->
		<dependency>
			<groupId>javassist</groupId>
			<artifactId>javassist</artifactId>
			<version>3.12.0.GA</version>
		</dependency>
		
		<!-- hibernate c3p0 -->
		<dependency>
			<groupId>org.hibernate</groupId>
			<artifactId>hibernate-c3p0</artifactId>
			<version>${hibernate-c3p0-version}</version>
		</dependency>

		<!-- logger -->
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-log4j12</artifactId>
			<version>1.6.1</version>
		</dependency>
	</dependencies>

	<build>
		<plugins>
			<plugin>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>2.3.2</version>
				<configuration>
					<source>1.6</source>
					<target>1.6</target>
					<encoding>UTF-8</encoding>
				</configuration>
			</plugin>
		</plugins>
	</build>
</project>
```
<br />
----

## 基于xml的hibernate mysql demo
### 配置文件如下
```xml
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE hibernate-configuration PUBLIC
"-//Hibernate/Hibernate Configuration DTD 3.0//EN"
"http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
<hibernate-configuration>
	<session-factory>
		<property name="hibernate.dialect">org.hibernate.dialect.MySQLDialect</property>
		<property name="hibernate.connection.driver_class">com.mysql.jdbc.Driver</property>
		<property name="hibernate.connection.url">jdbc:mysql://localhost:3306/test?characterEncoding=UTF-8&amp;useUnicode=true</property>
		<property name="hibernate.connection.username">root</property>
		<property name="hibernate.connection.password">167118</property>
		<property name="hibernate.bytecode.use_reflection_optimizer">false</property>
		<property name="show_sql">true</property>

		<!-- c3p0 config -->
		<property name="hibernate.c3p0.min_size">4</property>
		<property name="hibernate.c3p0.max_size">100</property>
		<property name="hibernate.c3p0.max_statements">100</property>
		<property name="hibernate.c3p0.timeout">600</property>
		<property name="hibernate.c3p0.idle_test_period">600</property>

		<mapping resource="com/hibernate/xml/entity/Stock.hbm.xml" />
		<mapping resource="com/hibernate/xml/entity/StockDetail.hbm.xml" />
		<mapping resource="com/hibernate/xml/entity/Member.hbm.xml" />
		<mapping resource="com/hibernate/xml/entity/MemberCard.hbm.xml" />
		<mapping resource="com/hibernate/xml/entity/Teacher.hbm.xml" />
		<mapping resource="com/hibernate/xml/entity/Student.hbm.xml" />
	</session-factory>
</hibernate-configuration>
```
### 测试采用h2内存库模式：便于测试的执行。
```xml
<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
<hibernate-configuration>
	<session-factory>
		<property name="hibernate.dialect">org.hibernate.dialect.H2Dialect</property>
		<property name="hibernate.connection.driver_class">org.h2.Driver</property>
		<property name="hibernate.connection.url">jdbc:h2:mem:test</property>
		<property name="hibernate.connection.username">su</property>
		<property name="hibernate.connection.password"></property>
		<property name="hibernate.bytecode.use_reflection_optimizer">false</property>
		<property name="hibernate.hbm2ddl.auto">create-drop</property>
		<property name="show_sql">true</property>

		<!-- c3p0 config -->
		<property name="hibernate.c3p0.min_size">4</property>
		<property name="hibernate.c3p0.max_size">100</property>
		<property name="hibernate.c3p0.max_statements">100</property>
		<property name="hibernate.c3p0.timeout">600</property>
		<property name="hibernate.c3p0.idle_test_period">600</property>

		<mapping resource="com/hibernate/xml/entity/Stock.hbm.xml" />
		<mapping resource="com/hibernate/xml/entity/StockDetail.hbm.xml" />
		<mapping resource="com/hibernate/xml/entity/Member.hbm.xml" />
		<mapping resource="com/hibernate/xml/entity/MemberCard.hbm.xml" />
		<mapping resource="com/hibernate/xml/entity/Teacher.hbm.xml" />
		<mapping resource="com/hibernate/xml/entity/Student.hbm.xml" />
	</session-factory>
</hibernate-configuration>
```
<br />
----

## 基于annotation的hibernate mysql demo
### xml配置文件略有不同：映射方式不一样。
<font color="red">
注意：hibernate从3.6开始xml和annotation配置的类都可以通过"org.hibernate.cfg.Configuration"读取。之前的版本annotation配置需要通过"org.hibernate.cfg.AnnotationConfiguration"读取。</font>
```xml
<mapping class="com.hibernate.annotation.entity.Stock" />
<mapping class="com.hibernate.annotation.entity.StockDetail" />
<mapping class="com.hibernate.annotation.entity.Member" />
<mapping class="com.hibernate.annotation.entity.MemberCard" />
<mapping class="com.hibernate.annotation.entity.Teacher" />
<mapping class="com.hibernate.annotation.entity.Student" />
<mapping class="com.hibernate.annotation.entity.Agent" />
<mapping class="com.hibernate.annotation.entity.Customer" />
<mapping class="com.hibernate.annotation.entity.AgentCustomer" />
```
### 实体类
* one-to-one
```java
/**
 * stock: 与stockDetail是一对一的关系
 * 
 * @author Administrator
 *
 */
@Entity
@Table(name = "stock", uniqueConstraints = {
		@UniqueConstraint(columnNames = "stock_code"),
		@UniqueConstraint(columnNames = "stock_name") })
public class Stock implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "stock_id", unique = true, nullable = false)
	private Integer stockId;

	@OneToOne(mappedBy = "stock")
	@Cascade({ CascadeType.SAVE_UPDATE, CascadeType.DELETE })
	private StockDetail stockDetail;

	@Column(name = "stock_code", length = 10, nullable = false)
	private String stockCode;

	@Column(name = "stock_name", length = 20, nullable = false)
	private String stockName;

	public Stock() {
	}

	public Stock(Integer stockId, StockDetail stockDetail, String stockCode,
			String stockName) {
		super();
		this.stockId = stockId;
		this.stockDetail = stockDetail;
		this.stockCode = stockCode;
		this.stockName = stockName;
	}

	// getter/setter
}
```
<br />
```java
/**
 * stockDetail: 与stock是一对一的关系 
 * 
 * @author Administrator
 *
 */
@Entity
@Table(name = "stock_detail", uniqueConstraints = { @UniqueConstraint(columnNames = "comp_name") })
public class StockDetail implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "stock_id")
	@GenericGenerator(name = "generator", strategy = "foreign", parameters = @Parameter(name = "property", value = "stock"))
	@GeneratedValue(generator = "generator")
	private Integer stockId;

	@OneToOne
	@PrimaryKeyJoinColumn
	private Stock stock;

	@Column(name = "comp_name", length = 20, nullable = false)
	private String compName;

	@Column(name = "comp_desc", length = 200)
	private String compDesc;

	@Column(name = "remark", length = 255)
	private String remark;

	@Temporal(TemporalType.DATE)
	@Column(name = "listed_date", length = 10)
	private Date listedDate;

	public StockDetail() {
	}

	public StockDetail(Integer stockId, Stock stock, String compName,
			String compDesc, String remark, Date listedDate) {
		super();
		this.stockId = stockId;
		this.stock = stock;
		this.compName = compName;
		this.compDesc = compDesc;
		this.remark = remark;
		this.listedDate = listedDate;
	}

	// getter/setter
}
```

* one-to-many
```java
/**
 * 会员：与会员卡是一对多的关系
 * 
 * @author sean
 * 
 */
@Entity
@Table(name = "member", uniqueConstraints = { @UniqueConstraint(columnNames = "member_name") })
public class Member implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "member_name", length = 20, nullable = false)
	private String memberName;

	@OneToMany(mappedBy = "member", fetch = FetchType.LAZY)
	@Cascade({ CascadeType.SAVE_UPDATE, CascadeType.DELETE })
	private Set<MemberCard> memberCards;

	public Member() {
	}

	public Member(Integer id, String memberName, Set<MemberCard> memberCards) {
		super();
		this.id = id;
		this.memberName = memberName;
		this.memberCards = memberCards;
	}

	// getter/setter
}
```
<br />
```java
/**
 * 会员卡：与会员是多对一的关系
 * 
 * @author sean
 * 
 */
@Entity
@Table(name = "member_card", uniqueConstraints = { @UniqueConstraint(columnNames = "card_no") })
public class MemberCard implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "card_no", length = 20, nullable = false)
	private String cardNo;

	@ManyToOne
	@JoinColumn(name = "member_id", referencedColumnName="id")
	private Member member;

	public MemberCard() {
	}

	public MemberCard(Integer id, String cardNo, Member member) {
		super();
		this.id = id;
		this.cardNo = cardNo;
		this.member = member;
	}

	// getter/setter
}
```

* many-to-many
```java
/**
 * 老师：与学生是多对多的关系。
 * 
 * @author sean
 * 
 */
@Entity
@Table(name = "teacher", uniqueConstraints = { @UniqueConstraint(columnNames = "teacher_name") })
public class Teacher implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "teacher_name", nullable = false, length = 20)
	private String teacherName;

	/**
	 * 定义mappedBy的对方是关系的拥有方，维护关系。
	 */
	@ManyToMany(mappedBy = "teachers")
	@OrderBy("studentName asc")
	@Cascade({ CascadeType.SAVE_UPDATE, CascadeType.DELETE })
	private Set<Student> students;

	public Teacher() {
	}

	public Teacher(Integer id, String teacherName, Set<Student> students) {
		super();
		this.id = id;
		this.teacherName = teacherName;
		this.students = students;
	}

	// getter/setter
}
```
<br />
```java
/**
 * 学生：和老师是多对多的关系
 * 
 * @author sean
 * 
 */
@Entity
@Table(name = "student", uniqueConstraints = { @UniqueConstraint(columnNames = { "student_name" }) })
public class Student implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "student_name", nullable = false, length = 20)
	private String studentName;
	
	/**
	 * mappedBy定义在被拥有方：老师拥有学生。
	 */
	@ManyToMany(fetch = FetchType.LAZY)
	@OrderBy("teacherName asc")
	@JoinTable(name = "teacher_student", joinColumns = @JoinColumn(name = "student_id", nullable = false, updatable = false), inverseJoinColumns = @JoinColumn(name = "teacher_id", nullable = false, updatable = false))
	private Set<Teacher> teachers;

	public Student() {
	}

	public Student(Integer id, String studentName, Set<Teacher> teachers) {
		super();
		this.id = id;
		this.studentName = studentName;
		this.teachers = teachers;
	}

	// getter/setter
}
```

* many-to-many(extra column)：中间表有额外的字段。
```java
/**
 * 代理商：与客户是多对多的关系，中间实体AgentCustomer有除关系的额外字段
 * 
 * @author Administrator
 * 
 */
@Entity
@Table(name = "agent", uniqueConstraints = { @UniqueConstraint(columnNames = "agent_name") })
public class Agent implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "agent_name", length = 20, nullable = false)
	private String agentName;

	// orphanRemoval：级联删除孤立节点
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "pk.agent", orphanRemoval = true)
	@OrderBy("pk.customer asc")
	@Cascade({ CascadeType.SAVE_UPDATE, CascadeType.DELETE })
	private Set<AgentCustomer> agentCustomers;

	public Agent() {
	}

	public Agent(Integer id, String agentName, Set<AgentCustomer> agentCustomers) {
		super();
		this.id = id;
		this.agentName = agentName;
		this.agentCustomers = agentCustomers;
	}

	// getter/setter
}
```
<br />
```java
/**
 * 客户：和代理商是多对多的关系，中间实体AgentCustomer有除关系的额外字段
 * 
 * @author Administrator
 * 
 */
@Entity
@Table(name = "customer", uniqueConstraints = { @UniqueConstraint(columnNames = "customer_name") })
public class Customer implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "customer_name", nullable = false, length = 20)
	private String customerName;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "pk.customer")
	@OrderBy("pk.agent asc")
	private Set<AgentCustomer> agentCustomers;

	public Customer() {
	}

	public Customer(Integer id, String customerName,
			Set<AgentCustomer> agentCustomers) {
		super();
		this.id = id;
		this.customerName = customerName;
		this.agentCustomers = agentCustomers;
	}

	// getter/setter
}
```
<br />
```java
/**
 * 复合主键
 * 
 * @author Administrator
 * 
 */
@Embeddable
public class AgentCustomerId implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@ManyToOne
	private Agent agent;
	@ManyToOne
	private Customer customer;

	public AgentCustomerId() {
	}

	public AgentCustomerId(Agent agent, Customer customer) {
		super();
		this.agent = agent;
		this.customer = customer;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null || getClass() != obj.getClass()) {
			return false;
		}
		AgentCustomerId that = (AgentCustomerId) obj;
		if (agent != null ? !agent.equals(that.agent) : that.agent != null) {
			return false;
		}
		if (customer != null ? !customer.equals(that.customer)
				: that.customer != null) {
			return false;
		}
		return true;
	}

	@Override
	public int hashCode() {
		int result;
		result = agent != null ? agent.hashCode() : 0;
		result = 31 * result + (customer != null ? customer.hashCode() : 0);
		return result;
	}
	
	// getter/setter
}
```
<br />
```java
/**
 * 代理商与客户的中间关系实体
 * 
 * @author Administrator
 *
 */
@Entity
@Table(name = "agent_customer")
@AssociationOverrides({
		@AssociationOverride(name = "pk.agent", joinColumns = @JoinColumn(name = "agent_id")),
		@AssociationOverride(name = "pk.customer", joinColumns = @JoinColumn(name = "customer_id")) })
public class AgentCustomer implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@EmbeddedId
	private AgentCustomerId pk;

	@Temporal(TemporalType.DATE)
	@Column(name = "created_date", length = 10, nullable = false)
	private Date createdDate;
	@Column(name = "created_by", length = 20, nullable = false)
	private String createdBy;

	public AgentCustomer() {
	}

	public AgentCustomer(AgentCustomerId pk, Date createdDate, String createdBy) {
		super();
		this.pk = pk;
		this.createdDate = createdDate;
		this.createdBy = createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public Agent getAgent() {
		return getPk().getAgent();
	}

	public void setAgent(Agent agent) {
		getPk().setAgent(agent);
	}

	public Customer getCustomer() {
		return getPk().getCustomer();
	}

	public void setCustomer(Customer customer) {
		getPk().setCustomer(customer);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null || getClass() != obj.getClass()) {
			return false;
		}
		AgentCustomer that = (AgentCustomer) obj;
		if (getPk() != null ? !getPk().equals(that.getPk())
				: that.getPk() != null) {
			return false;
		}
		return true;
	}

	@Override
	public int hashCode() {
		return (getPk() != null ? getPk().hashCode() : 0);
	}
	
	// getter/setter
}
```