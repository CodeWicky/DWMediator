# DWMediator

### 中间件背景

中间件是为了完成组件化后，组件间通信而产生的一种设计模式。

DWMediator一个中间件方案，免注册无入侵的实现组件间解耦，借鉴了CTMediator和BeeHive的思想。

市面上主流的中间件方案目前有三种：

- Target-Action 方案
- URL Router 方案
- Protocol-Class 方案

Target-Action方案代表就是`CTMediator`。核心代码不过100多行，却可以实现免注册、无入侵的中间件方案。对应每个不同的业务要为`CTMediator`添加分类类规定参数的传递。不足之处是Action要硬编码在分类中，不方便查出问题。

URL Router 方案代表是蘑菇街的`MGJRouter`。使用URL进行中间件管理。不足之处是需要管理URL的表，并且不能传递特殊类型的数据，如UIImage等。

Protocol-Class方案最初也是由`MGJRouter`提出的，其为了补足URL Router不能传递特殊参数的问题而设计。不过同样需要注册。

市面上其他的较为出色的中间件方案都是在上面的三个方案基础上发展而来的，包括阿里开源的`BeeHive`及网易开源的`LDBusMediator`。

DWMediator则是借鉴了`CTMediator`和`BeeHive`两者的思想实现的Protocol-Class模式的中间件方案。固化了Protocol与Module的对应关系从而实现免注册的模式，然后通过遵循协议的Module完成对第二个组件的调用。通过协议可以避免硬编码来确定方法选择子的问题。

### 使用方法

首先，需求是组件A想要与组件B进行通信。那么大概要做如下几步：

- 1.组件A、组件B依赖**DWMediator**
- 2.为组件B创建专用的Protocol，例如**Protocol_B**。并将Protocol_B与DWMediator封装在一个中间件组件中。
- 3.为组件B创建专用Module，如果协议名叫**Protocol_B**，那么Module名为**Protocol_B_Module**。这里Module名要遵守这个规范，这是免注册的关键点。同时Module要**遵循Protocol_B协议**，Module中可以引入组件B并在**协议方法中调用组件B的接口**。最后把Module跟组件B封装成一个组件。至此组件B的准备工作已经完成。
- 4.最后，在组件A中想要调用组件B的地方，**根据协议Protocol_B生成一个遵循Protocol_B协议的id类型实例**。然后直接调用协议接口即可。




