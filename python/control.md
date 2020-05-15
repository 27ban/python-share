#### 流程控制

##### 条件控制

```python
found = True
if found:
    pass
else:
    pass
```

```python
count = 66
if count >= 80:
    pass
elif count<80 and count >= 60:
    pass
else:
    pass
```

##### 循环控制

```python
for i in range(10):
    print(i)
```

```python
count = 88
while count>20:
    count -= 1
```

##### 顺序执行
无论是条件还是循环控制流程，归根结底是还是从上到下逐行按顺序执行，python执行按照下面顺序执行：

1.普通语句，直接执行
2.函数，载入内存，不直接执行
3.类，只执行普通语句，不执行类方法，只载入
4.if,for,while等控制语句，按相应的流程执行
5.@按相应的流程执行

##### __ name __ 和 __ main __
每个模块都有__name__属性，其值根据调用方式不同而不同，如果是直接调用则是__main__，如果是通过模块调用则是模块名，常常根据其值来表示如何调用该模块
