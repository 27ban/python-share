# 2.Python面向对象

### 2.1:面向对象
面向过程:把函数切分为子函数，即把大块函数通过切割成小块函数来降低系统的复杂度.

面向对象:把计算机程序视为一组对象的集合，而每个对象都可以接收其他对象发过来的消息，并处理这些消息
可以对现实事物、问题进行抽象编程,把对象作为程序的基本单元，一个对象包含了数据和操作数据的函数。
```py
std1 = { 'name': 'Michael', 'score': 98 }
std2 = { 'name': 'Bob', 'score': 81 }
def print_score(std):
    print('%s: %s' % (std['name'], std['score']))

class Student(object):
    def __init__(self, name, score):
        self.name = name
        self.score = score
    def print_score(self):
        print('%s: %s' % (self.name, self.score))

bart = Student('Bart Simpson', 59)
lisa = Student('Lisa Simpson', 87)
bart.print_score()
lisa.print_score()
```
我们定义的Class——Student，是指学生这个概念，而实例（Instance）则是一个个具体的Student，比如，Bart Simpson和Lisa Simpson是两个具体的Student。
面向对象的设计思想是抽象出Class，根据Class创建Instance。
面向对象的抽象程度又比函数要高，因为一个Class既包含数据，又包含操作数据的方法。

### 2.2:类属性和实例属性

```py
class Student(object):
    #self指代是对象本身,代表当前对象的地址
    #self表示当前实例化对象 
    def __init__(self, name, score):
        self.name = name
        self.score = score
    
    def get_grade(self):
        if self.score >= 90:
            return 'A'
        elif self.score >= 60:
            return 'B'
        else:
            return 'C'

lisa = Student('Lisa', 99)
bart = Student('Bart', 59)
print(lisa.name, lisa.get_grade())
print(bart.name, bart.get_grade())
```
```py
class S(object):
    name = "sss"

class S(object):
    def __init__(self):
        self.name = "sss"
```
```py
class T(object):
    name = "hello"
    def b(self):
        self.name = "world"
    def h(self):
        print(name)
        # print(self.name)
```
千万不要对实例属性和类属性使用相同的名字，因为相同名称的实例属性将屏蔽掉类属性，但是当你删除实例属性后，再使用相同的名称，访问到的将是类属性。

类是创建实例的模板，而实例则是一个一个具体的对象，各个实例拥有的数据都互相独立，互不影响；
方法就是与实例绑定的函数，和普通函数不同，方法可以直接访问实例的数据；
通过在实例上调用方法，我们就直接操作了对象内部的数据，但无需知道方法内部的实现细节。

### 2.3:静态方法和类方法
* 实例方法
```py
class Dog(object):
    def __init__(self,name):
        self.name = name

    def eat(self,food):
        print("%s is eating %s"%(self.name,food))
d = Dog("GOU")
d.eat("GUTOU")
```
*  静态方法
```py
class Dog(object):
    hello = "xxxx"
    def __init__(self,name):
        self.name = name
    @staticmethod
    def eat():
        print("%s is eating %s"%("name","tt"))
        print(hello)
        # print(self.name)
d = Dog("GOU")
d.eat()
Dog.eat()
```
当eat函数变为静态方法时，此时静态方法将eat函数与类Dog之间的关联截断，之前调用类下面的方法会自动传self，如果用了staticmethod，那么就可以无视这个self，而将这个方法当成一个普通的函数使用。
静态方法是个独立的、单纯的函数，它仅仅托管于某个类的名称空间中，便于使用和维护,不能访问实例变量和类属性

* 类方法
```py
class Dog(object):
    hello = "hello"
    def __init__(self,name):
        self.name = name
    @classmethod
    def eat(cls):
        cls.h="hello"
        print("%s is eating %s"%(cls.h,"xx"))
        print(cls.hello)
        # print(self.name)
d = Dog("Gou")
d.eat()
Dog.eat()
```
类方法是将类本身作为对象进行操作的方法。类方法只能访问类变量，不能访问实例变量。


| 属性 | 方法 |
| -:- | -:- |
| 实例方法| 可以用类方法和静态方法,但不建议|
| 静态方法| 不能访问实例方法和类方法|
| 类方法 | 能访问类属性,不能访问实例属性和方法|

#### 三大特点:数据封装、继承和多态

### 2.4:继承和多态

* 继承
```py
class Animal(object):
    def run(self):
        print('Animal is running...')
class Dog(Animal):
    pass
class Cat(Animal):
    pass
dog = Dog()
dog.run()
cat = Cat()
cat.run()
```

* 多态
```py
def run_twice(animal):
    animal.run()
    animal.run()
run_twice(Animal())
run_twice(Dog())
run_twice(Cat())
class Tortoise(Animal):
    def run(self):
        print('Tortoise is running slowly...')
run_twice(Tortoise())
```
新增一个Animal的子类，不必对run_twice()做任何修改，实际上，任何依赖Animal作为参数的函数或者方法都可以不加修改地正常运行，原因就在于多态.
多态的好处就是，当我们需要传入Dog、Cat、Tortoise……时，我们只需要接收Animal类型就可以了，因为Dog、Cat、Tortoise……都是Animal类型，然后，按照Animal类型进行操作即可。由于Animal类型有run()方法，因此，传入的任意类型，只要是Animal类或者子类，就会自动调用实际类型的run()方法.

#### 对扩展开放,对修改封闭


### 2.5:魔法方法
#### 构造和初始化
* __init__初始化对象时使用，定义这个对象的初始值
```py
class Person(object):
    def __init__(self,name,age):
        self.name = name
        self.age = age
p = Person('Lisa',18)
```
* __new__创建实例化对象时调用,他是对象实例化时第一个被调用，然后再调用__init__
```py
# 单例模式
class Singleton(object):
    _instance = None
    def __new__(cls,*args,**kwargs):
        if not cls._instance:
            cls._instance = super(Singleton,cls).__new__(cls,*args,**kwargs)
        return cls._instance
class MySingleton(Singleton):
    pass
a = MySingleton()
b = MySingleton()
a.values = "2343"
print(b.values)
print(a is b)
# 使用场景是当你需要继承内置类时，例如int、str、tuple，只能通过__new__来达到初始化数据的效果
class g(int):
    def __init__(self,value):
        super(g,self).__init__(self,abs(value))
class g(int):
    def __new__(cls,value):
        return float.__new__(cls,abs(value))
a = g(-23)
print(a)
```
* __del__在对象被垃圾回收时才被调用，del x不一定会执行此方法。
```py
class Person(object):
    def __del__(self):
        print('__del__',self)
a = Person()
del a
c = Person()
d = c
del c
```

#### 类的表示
* __str__强调可读性,__repr__强调准确性/标准性
```py
class Person(object):
    def __init__(self,name,age):
        self.name=name
        self.age=age
    def __str__(self):
        return 'name:%s,age:%s' % (self.name,self.age)
    def __repr__(self):
        return "Person('%s',%s)" %(self.name,self.age)
person = Person('zhang',23)
print(str(person))
print( '%s'%person)
print(repr(person))
print('%r'%person)
```

#### 访问控制
* __setattr__设置属性
* __getattr__访问不存在的属性
* __delattr__删除某个属性
* __getattribute__访问任意属性或方法

```py
class Person(object):
    def __setattr__(self, key, value):
        """属性赋值"""
        if key not in ('name', 'age'):
            return
        if key == 'age' and value < 0:
            raise ValueError()
        super(Person, self).__setattr__(key, value)
    def __getattr__(self, key):
        """访问某个不存在的属性"""
        return 'unknown'
    def __delattr__(self, key):
        """删除某个属性"""
        if key == 'name':
            raise AttributeError()
        super(Person, self).__delattr__(key)
    def __getattribute__(self, key):
        """所有属性/方法调用都经过这里"""
        if key == 'money':
            return 100
        if key == 'hello':
            return self.say
        return super(Person, self).__getattribute__(key)
    def say(self):
        return 'hello'
p1 = Person()
p1.name = 'zhangsan'	# 调用__setattr__
p1.age = 20				# 调用__setattr__
print (p1.name)	# zhangsan
print (p1.age)	# 20
setattr(p1, 'name', 'lisi')	# 调用__setattr__
setattr(p1, 'age', 30)		# 调用__setattr__
print (p1.name)	# lisi
print (p1.age)	# 30
p1.gender = 'male'	# __setattr__中忽略对gender赋值
print (p1.gender)	# gender不存在,调用__getattr__返回：unknown
print (p1.money)	# money不存在,在__getattribute__中返回100
print (p1.say())	# hello
print(p1.hello())# hello,调用__getattribute__，间接调用say方法
del p1.name		# __delattr__中引发AttributeError
p2 = Person()
p2.age = -1
```
* __call__将类实例对象变成可调用对象
```py
class X(object):
    def __call__(self):
        return 40
x = X()
x(10)
```
* __enter__/__exit__ 上下文管理
```py
class O(object):
    def __init__(self,name):
        print(name)
        self.name = name
    def __enter__(self):
        print('__enter__')
        return self
    def __exit__(self,exc_type,exc_val,exc_tb):
        print('__exit__')
with O('hello') as o:
    o.name
```

### 2.6:元类(metaclass创建类的模版)
#### 先定义metaclass，就可以创建类，最后创建实例。
*  type()又可以创建新的类型
```py
class Hello(object):
    def hello(self,name="world"):
        print(name)
h = Hello()
h.hello()
print(type(Hello))
print(type(h))
```
```py
def fn(self,name="world"):
    print(name)
Hello = type('Hello',(object,),dict(hello=fn))
h = Hello()
h.hello()
print(type(Hello))
print(type(h))
```
* 创建一个自定义的元类,必须是继承type的
```py
class ListMetaclass(type):
    def __new__(cls, name, bases, attrs):
        attrs['add'] = lambda self, value: self.append(value)
        return type.__new__(cls, name, bases, attrs)
class MyList(list,metaclass=ListMetaclass):
    pass
L = MyList()
L.add(1)
print(L)
print(type(L))
```

###2.7:Python中的type 和 object

![JPG](\images\python_type_object.jpg)

参考链接
[--CSDN--](https://blog.csdn.net/piglite/article/details/78294112)
