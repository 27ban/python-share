### python闭包
#### 闭包：python中一切皆对象,函数也是对象.当某个函数被当成对象返回时,并且内函数里运用了外函数的临时变量,就形成类一个闭包
```py
def hello():
    a = 'hello'
    def app():
        print('hello')
    return app
```
#### 判断一个函数是否是一个闭包函数时调用他的__closure__属性,返回不为空的元祖就是一个闭包函数
```py
# 外部函数
def outer(a):
    b = 20 # a,b外函数的临时变量
    # 内函数
    def inner():
        # 在函数中调用了外函数的临时变量
        print(a+b)
    # 返回内函数的引用
    return inner
a = outer(5)
a()
```
#### 在闭包内函数中，我们可以随意使用外函数的临时变量,那么我们可以修改吗？
##### 在python中如何修改全局变量
```py
a = "abcdefg"
def test():
    global a
    a = "123456"
test()
print(a)
```
```py
l = ['a','b','c']
def test():
    l[0]=['0000']
test()
print(l)
```
##### 1.用global声明(不可变类型) 2.如果是可变类型的话可以直接修改
```py
def outer():
    a = 10
    b = [123]
    def inner():
        nonlocal a
        a +=1
        b[0] +=10
        print(a,b)
    return inner
a = outer()
a()
```
##### python3中可以用nonlocal声明,表示这个变量不是局部变量空间的变量，需要向上一层变量空间找这个变量。
```py
def outer(x):
    def inner(y):
        nonlocal x
        print(x,y)
    return inner
a = outer(20)
a(10)
a(12)
```
##### 每次调用内函数都在使用同一份闭包变量
#### 应用场景
* 装饰器
```py
def log(func):
    def wrapper(*args,**kw):
        print("write_log")
        return func(*args,**kw)
    return wrapper
@log
def h():
    print('test')
h()
# log(h).__closure__
```
* 装饰器执行顺序

```py
def a(f):
    print('enter a')
    def wrapper(*args,**kw):
        print('execute a')
        return f(*args,**kw)
    return wrapper
def b(f):
    print('enter b')
    def wrapper(*args,**kw):
        print('execute b')
        return f(*args,**kw)
    return wrapper
@a
@b
def log():
    print('write_log')

log()
# a(b(log))()
```

* 面向对象编程
闭包可以把闭包变量给内函数，类创建的对象具有相同的属性和方法，所以闭包也是实现面向对象的方法之一
```py
def line_conf(a,b):
    def line(x):
        return a*x+b
    return line
l = line_conf(2,3)
y = l(5)
y = l(6)
class Line(object):
    def __init__(self,a,b):
        self.a = a
        self.b = b
    def get_y(self,x):
        return self.a*x+self.b
l = Line(2,3)
y = l.get_y(5)
y = l.get_y(6)
```
相对于这种单方法类，使用闭包会显得更加简洁和优雅一些。

### 上下文管理(代码块执行前准备,执行后收拾)
#### 上下文管理协议:包含方法 __enter__() 和 __exit__()，支持该协议的对象要实现这两个方法
#### 上下文管理器:定义执行 with 语句时要建立的运行时上下文，负责执行 with 语句块上下文中的进入与退出操作。通常使用 with 语句调用上下文管理器，也可以通过直接调用其方法来使用。

#### 创建上下文管理器的方法
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
```py
# 上下文管理工具
from contextlib import contextmanager
@contextmanager
def demo():
    print ('executes in __enter__')
    yield '*** contextmanager demo ***'
    print ('executes in __exit__')
 
with demo() as value:
    print ('Assigned Value: %s' % value)
```

#### 应用场景,主要应用与资源创建与释放，比如:数据库的连接，查询，关闭处理\文件的打开和关闭
```py
class Database(object):
    def __init__(self):
        self.connected = False
    def connect(self):
        self.connected = True
    def close(self):
        self.connected = False
    def query(self):
        if self.connected:
            return 'query data'
        else:
            raise ValueError('DB not connected ')
def handle_query():
    db = Database()
    db.connect()
    print ('handle --- ', db.query())
    db.close()
handle_query()
```
```py
class Database(object):
    def __init__(self):
        self.connected = False
    def __enter__(self):
        self.connected = True
        print(self.connected)
        return self
    def __exit__(self,*args):
        self.connected = False
        print(self.connected)
    def query(self):
        if self.connected:
            print( 'query data')
        else:
            raise ValueError('DB not connected ')
with Database() as db:
    db.query()
```