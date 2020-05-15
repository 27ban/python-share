相对于这种单方法类，使用闭包会显得更加简洁和优雅一些。

### 上下文管理(代码块执行前准备,执行后收拾)

#### 上下文管理协议:包含方法 **enter**() 和 **exit**()，支持该协议的对象要实现这两个方法

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