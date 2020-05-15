#### 模块和包

##### import和from

- import和from都是赋值语句
```python
# a.py
X = 30
def printer():
    print(X)
```

```python
# b.py
from a import X, printer 
X = 99
printer()
# 30
```

##### 相对导入
包含相对路径的模块，只能被引用，不能直接执行，其相对路径指当前模块的路径。

##### __ all __ 最小化from * 的破坏

