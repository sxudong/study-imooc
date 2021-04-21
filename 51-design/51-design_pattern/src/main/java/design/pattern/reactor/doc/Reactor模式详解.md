# Reactor模式详解



链接：https://www.jianshu.com/p/188ef8462100

## 1.Reactor模式介绍

Reactor模式是事件驱动模型，有一个或多个并发输入源，有一个Service Handler，有多个Request Handlers；这个Service Handler会同步的将输入的请求（Event）多路复用的分发给相应的Request Handler。从结构上，这有点类似生产者消费者模式，即有一个或多个生产者将事件放入一个Queue中，而一个或多个消费者主动的从这个Queue中Poll事件来处理；而Reactor模式则并没有Queue来做缓冲，每当一个Event输入到Service Handler之后，该Service Handler会主动的根据不同的Event类型将其分发给对应的Request Handler来处理。



![img](https:////upload-images.jianshu.io/upload_images/4720632-772107bb22dac4a0.png?imageMogr2/auto-orient/strip|imageView2/2/w/527/format/webp)

Reactor类图

该图为Reactor模型，实现Reactor模式需要实现以下几个类：

1）EventHandler：事件处理器，可以根据事件的不同状态创建处理不同状态的处理器；

2）Handle：可以理解为事件，在网络编程中就是一个Socket，在数据库操作中就是一个DBConnection；

3）InitiationDispatcher：用于管理EventHandler，分发event的容器，也是一个事件处理调度器，Tomcat的Dispatcher就是一个很好的实现，用于接收到网络请求后进行第一步的任务分发，分发给相应的处理器去异步处理，来保证吞吐量；

4）Demultiplexer：阻塞等待一系列的Handle中的事件到来，如果阻塞等待返回，即表示在返回的Handle中可以不阻塞的执行返回的事件类型。这个模块一般使用操作系统的select来实现。在Java NIO中用Selector来封装，当Selector.select()返回时，可以调用Selector的selectedKeys()方法获取Set<SelectionKey>，一个SelectionKey表达一个有事件发生的Channel以及该Channel上的事件类型。



![img](https:////upload-images.jianshu.io/upload_images/4720632-9146b59382d59ebf.png?imageMogr2/auto-orient/strip|imageView2/2/w/546/format/webp)

Reactor时序图

1）初始化InitiationDispatcher，并初始化一个Handle到EventHandler的Map。

2）注册EventHandler到InitiationDispatcher中，每个EventHandler包含对相应Handle的引用，从而建立Handle到EventHandler的映射（Map）。

3）调用InitiationDispatcher的handle_events()方法以启动Event Loop。在Event Loop中，调用select()方法（Synchronous Event Demultiplexer）阻塞等待Event发生。

4）当某个或某些Handle的Event发生后，select()方法返回，InitiationDispatcher根据返回的Handle找到注册的EventHandler，并回调该EventHandler的handle_events()方法。

5）在EventHandler的handle_events()方法中还可以向InitiationDispatcher中注册新的Eventhandler，比如对AcceptorEventHandler来，当有新的client连接时，它会产生新的EventHandler以处理新的连接，并注册到InitiationDispatcher中。



## 2.Reactor Java实现

介绍了这些估计大部分同学还是云里雾里，下面我们直接通过代码来实现一个简单的Reactor模式，Reactor模式相对于其它模式来说，就算是最简单的实现也涉及到不少类，这个例子只是为了体现该模式，所以没有实质的业务功能，如果要实现具体业务功能可以自行添加相关代码，网上很多例子都是基于Java NIO的一些类来实现的Reactor模式，这里我们实现没有依赖任何的NIO类库，这主要是方便大家理解该模式，性能上肯定是不如Netty这些NIO框架封装的要好，这样可以方便大家去学习这种模式的思想，该模式也不一定非用在NIO的地方，也可以用在其他的非阻塞需求的业务场景。

实现Reactor我们需要实现以下几个类：

**InputSource:** 外部输入类，用来表示需要reactor去处理的原始对象

**Event**: reactor模式的事件类，可以理解为将输入原始对象根据不同状态包装成一个事件类，reactor模式里处理的斗士event事件对象

**EventType**: 枚举类型表示事件的不同类型

**EventHandler**: 处理事件的抽象类，里面包含了不同事件处理器的公共逻辑和公共对象

**AcceptEventHandler\ReadEventhandler等**: 继承自EventHandler的具体事件处理器的实现类，一般根据事件不同的状态来定义不同的处理器

**Dispatcher**: 事件分发器，整个reactor模式解决的主要问题就是在接收到任务后根据分发器快速进行分发给相应的事件处理器，不需要从开始状态就阻塞

**Selector**: 事件轮循选择器，selector主要实现了轮循队列中的事件状态，取出当前能够处理的状态

**Acceptor**:reactor的事件接收类，负责初始化selector和接收缓冲队列

**Server**:负责启动reactor服务并启动相关服务接收请求

这个例子没有实现什么具体业务逻辑，只是把reactor模式的框架给实现了，大家如果要实现基于reactor模式的业务功能，可以自己定义InputSource、定义事件的不同状态、定义事件处理器，目前大家用的比较多的各种NIO框架就是reactor模式的很好实践，其实reactor模式不一定用在NIO上，也可以用在其他场合，这就要各位发挥自己的想象了，reactor只是一种设计模式，是一种基于事件响应的模式，大家心里一定要理解这点，好了下面开始贴代码。





## 3.Reactor优缺点

Reactor模式的核心是解决多请求问题，如果有特别多的请求同时发生，不会因为线程池被短时间占满而拒绝服务。我们一般实现多请求的模块，会采用线程池的实现方案，这种方案对于并发量不是特别大的场景是足够用的，一般来说单机tps1000以下都是够用的，但是线程池方案的最大缺点就是，如果瞬间有大并发则会一下子耗满线程，整个服务陷入阻塞中，后续请求将无法接入。基于Reactor模式实现的方案，会有一个Dispatcher先接收event，然后快速分发给相应的耗时eventHandler处理器去处理，这样就不会阻塞请求的接收。

Reactor模式和生产者消费者模式最大的区别在于，生产者消费者模式是基于队列的实现，能够解决生产端和消费端处理速度不同步的问题，queue可以基于Java Queue或者基于现有的MQ产品来实现；而Reactor模式是基于事件驱动模型，当接收到请求后会将请求封装成事件，并将事件分发给相应处理事件的Handler，handler处理完成后将事件状态修改为下一个状态，再由Reactor将事件分发给能够处理下一个状态的handler进行处理。两个模式解决的问题都是类似的，只是实现起来有所区别，这是我个人的理解。

介绍了那么多，Reactor模式的优点很明显，解耦、提升复用性、模块化、可移植性、事件驱动、细力度的并发控制等。Reactor模式的缺点也很明显，模型复杂，因为涉及到内部回调，多线程处理，不容易调试；需要操作系统底层支持，这就导致不同操作系统可能会产生不一样的结果。所以总的来说如果并发要求不是那么高，使用传统的阻塞线程池模型足够了，而且调试、查问题都会简单很多；如果我们的使用场景是会产生瞬时大并发，可以使用Reactor模式来实现，目前大部分的NIO框架或者容器都是实现了Reactor模式，Tomcat、Jetty的NIO都是实现了Reactor模式，Netty和Mina是两套NIO的框架，也分别对Java NIO进行了二次封装实现了Reactor模式。

作者：monkey01

链接：https://www.jianshu.com/p/188ef8462100

来源：简书

著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。