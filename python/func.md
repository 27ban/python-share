#### 高阶函数

- lambda匿名函数

- filter对元素进行过滤，返回符合条件的集合
```python
alist = [3,6,-1,-4,-2]
test = filter(lambda x: x > 0, alist)
print(test)
# [3,6]

```

- map对每个元素进行操作并返回其集合
```python
alist = [3,12,35,12,67]
res = map(lambda x:x+20, alist)
print(res)
# [23, 32, 55, 32, 87]

```

- reduce

```python
from functools import reduce
alist = [3,12,35,12,67]
count = reduce(lambda x,y: x+y, alist)
print(count)
# 129
```
