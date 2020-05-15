### 闭包

#### 闭包：python 中一切皆对象,函数也是对象.当某个函数被当成对象返回时,并且内函数里运用了外函数的临时变量,就形成类一个闭包

```py
def hello():
    a = 'hello'
    def app():
        print('hello')
    return app
```

#### 判断一个函数是否是一个闭包函数时调用他的**closure**属性,返回不为空的元祖就是一个闭包函数

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

##### 在 python 中如何修改全局变量

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

##### 用 global 声明(不可变类型) 2.如果是可变类型的话可以直接修改

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

##### python3 中可以用 nonlocal 声明,表示这个变量不是局部变量空间的变量，需要向上一层变量空间找这个变量。

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

#### 应用场景(装饰器)


- 装饰器执行顺序

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

- 类装饰器

```python
def log(f):
    print('log enter')
    def wraps(*args,**kwargs):
        return f(*args,**kwargs)
    return wraps
@log
class Base(object):
    def __init__(self):
        print('class __init__')
```

- 装饰器加参数

```python
def log(level, message=None):
    def decorate(func):
        def wrapper(*args,**kwargs):
            print(level, message)
            return func(*args,**kwargs)
        return wrapper
    return decorate
@log('INFO',message='ok')
def test():
    print('test')

```



- 装饰器的副作用

```python
from functools import  wraps
def log(func):
    @wraps(func)
    def wrappers(*args,**kwargs):
        '''
        wrappers
        '''
        return func(*args,**kwargs)
    return wrappers
@log
def test():
    '''
    test
    '''
    print('hello world')

print(test.__name__,test.__doc__)
# ('wrappers', '\n        wrappers\n        ')
# 加wraps后
# ('test', '\n    test\n    ')

```
被装饰后的函数已经编程了另外一个函数，函数名属性都会发生变化，所以需要消除这些影响。
wraps实际上是把这些属性重新改来一下。



