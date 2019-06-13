# 1.Python数据类型

### 变量有三问:"他是谁？他从哪里来？要到哪里去？"

#### 1.1 可变不可变,有序与无序

可变与不可变实际上是对一个对象进行操作，是否会重新创建一个对象，并将原来的变量重新指向新建的对象，如果没有其他变量引用原来对象的话，原来对象就会被回收

* 数字(**不可变对象**)
```py
a = 4
#id()获取对象的内存地址
print(id(a))
a +=1
print(a)
id(a)
```
补充:当多个变量值一样的时候
```py
a = 2
b = 2
id(a)
id(b)
```

* 字符串(**不可变,有序对象**)
```py
a = "hello"
#print(id(a))
print(a.replace("l","w"))
print(a)
#print(id(a))
```

* 列表(**可变,有序对象**)
```py
a = ['a','b','c','d']
print(a)
# print(id(a))
a[2] = 'eee'
print(a)
# print(id(a))
```
* 字典(**可变,无序对象**)
```py
d = {'a':"hello",'b':"world"}
# print(id(d))
d['a'] = "demo"
print(d)
# print(id(d))
```

* 元祖(**不可变,有序对象**)
```py
t = (1,2,3,4)
print(dir(t))
```
因为tuple不可变，所以代码更安全。如果可能，能用tuple代替list就尽量用tuple。

* 集合(**可变,无序,不可重复对象**)
```py
t = {1,2,3,5,3}
print(id(t))
t.add('1212')
print(t)
print(id(t))
```

| 类型 |     内容 |
| -:-   |-:-|
| 数字| 不可变|
| str| 不可变,有序|
| list| 可变,有序|
| dict| 可变,无序|
| tuple| 不可变,有序|
| set| 可变,无序|










#### 1.2 基本数据类型的方法

| 类型 |     方法 |
| -:-   |-:-|
| str | center,count,endswith,find,format,index,isalnum,isascii,isdecimal,isdigit,islower,join,lower,replace,split,startswith,strip,title,upper|
| list| append,clear,copy,count,extend,index,insert,pop,remove,reverse,sort|
| dict| clear,copy,fromkeys,get,items,keys,pop,popitem,setdefault,update,values|
| tuple| count,index|
| set| add,clear,copy,difference,difference_update,discard,isdisjoint,issubset,issuperset,pop,remove,union,update|


查看方法dir(type)
* str
```py
s = 'abcd \n ef12323'
s.index('e') # 查找元素所在位置,不存在会报错
s.find('e') # 查找元素所在位置,不存在是-1
s.startswith('a')  # 是否以所传元素开始，bool类型
s.endswith('23)
s.splitlines() # 以换行符分割
s.strip('23') # 用于移除字符串头尾指定的字符
s.islower() # 是否小写
s.lower() # 转换成小写
```
* list
```py
l = ['a','b','c','d']
l.append('e')
l.pop()
l.count('c')
l.index('b') # 查找元素所在位置,不存在会报错
l.insert(2,'c')
l.copy()
```


#### 1.3 相互转换

* 转list
```py
# 集合转list
a = {1,2,3,4,3}
print(list(a))
# dict转list
d = {'a':'b','c':'d','e':'f'}
print(list(d.keys()))
# tuple转list
t = (1,2,3,4,5)
print(list(t))
```
* 转dict
```py
# a = [(1,2),(3,4)]
a = ((1,2),(3,4))
d = {i:j for i,j in a}
```
* 转str
```py
s = ['a','b','c','d']
"".join(s)
```

#### 1.4 生成器

直接创建一个很长的列表，会占用很大的内存空间，有没有一种方法一边循环一边计算的机制，这样的机制叫生成器(generator)
```py
l = [x for x in range(15)]
g = (x for x in range(15))
```
生成器不但可以作用于for循环，还可以被next()函数不断调用并返回下一个值，直到最后抛出StopIteration错误表示无法继续返回下一个值
```py
next(g)
```

```py
def odd():
    print('step 1')
    yield 1
    print('step 2')
    yield(3)
    print('step 3')
    yield(5)
o = odd()
```

```py
def gener():
    for i in range(5):
        yield i
        print(i)
        # if i==3:
            # return i
for j in gener():
    print(j)
```
```py
def foo(num):
    print('start......')
    while True:
        res = yield 4
        print("res:" res)
g =foo()
print(next(g))
print('-'*20)
# print(g.send(7))
print(next(g))
```
此时foo就是一个生成器函数,next就相当于“下一步”生成哪个数，这一次的next开始的地方是接着上一次的next停止的地方执行的，所以调用next的时候，生成器并不会从foo函数的开始执行，只是接着上一步停止的地方开始，然后遇到yield后，return出要生成的数，此步就结束。
#### 1.5 迭代器

list,tuple,dict,str,set,生成器,yield 直接作用于for循环的统称可迭代对象Iterable

可以被next()函数调用并不断返回下一个值的对象称为迭代器：迭代器Iterator

凡是可作用于for循环的对象都是Iterable类型

凡是可作用于next()函数的对象都是Iterator类型

### 1.6 示例

```py
ss ='{}'.format('("'+str(tuple(df_2['学员编号'])[0])+'")' if df_2['学员编号'].shape[0] == 1 else tuple(str(x) for x in tuple(df_2['学员编号'])))
tt = '({})'.format(",".join(df_2['学员编号'].tolist()))
```

```py
sql_ks = '''
	select 
		stats_date,
		is_leader,
		ul.name,
		replace(fifth_level,'考核组','') department
	from
	   will_user_list_keguan_all ul
	left join will_department_list dl on dl.id = ul.department_id
	where first_level = '客户关系中心'
        and stats_date >= '{0}'
        and stats_date <= '{1}';
'''
sql_ks = sql_ks.format(start_date,stats_date)
```

```py
def response_df_format(resp):
    res = []
    for i in resp:
        for k, v in i.items():
            if str(v) in ["nan", "NaT", "None","null"]:
                i[k] = None
            if isinstance(v, datetime):
                i[k] = datetime.strftime(v, "%Y-%m-%d %H:%M")
            elif isinstance(v, date):
                i[k] = datetime.strftime(v, "%Y-%m-%d")
        res.append(i)
    return res
```

遍历一个集合及其下标
```py
colors = ['red','green','blue','yellow']
for i in range(len(colors)):
        print(i,colors[i])

for i, color in enumerate(colors):
    print(i,color)
```

遍历两个集合
```py
names = ['raymond', 'rachel', 'matthew']
colors = ['red', 'green', 'blue', 'yellow']
n = min(len(names), len(colors))
for i in range(n):
    print names[i], '--->', colors[i]

for name, color in zip(names, colors):
    print name, '--->', color
```

在循环内识别多个退出点
```py
def find(seq, target):
    found = False
    for i, value in enumerate(seq):
        if value == target:
            found = True
            break
    if not found:
        return -1
    return i

def find(seq, target):
    for i, value in enumerate(seq):
        if value == target:
            break
    else:
        return -1
    return i
```

用字典计数
```py
colors = ['red', 'green', 'red', 'blue', 'green', 'red']
# 简单，基本的计数方法。适合初学者起步时学习。
d = {}
for color in colors:
    if color not in d:
        d[color] = 0
    d[color] += 1


d = {}
for color in colors:
    d[color] = d.get(color, 0) + 1
```
更新多个变量的状态
```py
def fibonacci(n):
    x = 0
    y = 1
    for i in range(n):
        t = y
        y = x + y
        x = t

def fibonacci(n):
    x, y = 0, 1
    for i in range(n):
        x, y = y, x + y
```