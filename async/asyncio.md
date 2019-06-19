### 协程
* 子程序的切换由程序控制，没有线程切换的开销
* 因为只有一个线程，也就不用考虑锁的问题

```py
def producer(c):
    c.send(None)
    n =0
    while n<5:
        n +=1
        print("start producer",n)
        r = c.send(n)
        print("consumer status",r)
    c.close()
def consumer():
    r = ""
    while True:
        n = yield r
        if not n:
            return
        print("start consumer",n)
        r = "200 ok"

c = consumer()
producer(c)
```

```py
import threading
import asyncio

@asyncio.coroutine
def hello():
    print('Hello world! (%s)' % threading.currentThread())
    yield from asyncio.sleep(1)
    print('Hello again! (%s)' % threading.currentThread())

loop = asyncio.get_event_loop()
tasks = [hello(), hello()]
loop.run_until_complete(asyncio.wait(tasks))
loop.close()
```
```py
import time,threading
start =time.time()
balance = 0
def change_it(n):
	global balance
	balance +=n
	balance -=n
def run_thread(n):
	for _ in range(1000000):
		change_it(n)
t1 = threading.Thread(target=run_thread,args=(5,))
t2 = threading.Thread(target=run_thread,args=(8,))
t1.start()
t2.start()
t1.join()
t2.join()
print(balance)
print(time.time()-start)
```

```py
import aysncio
import time
start = time.time()
balance = 0
def change_it():
    global balance
    yield balance
    balance +=1
    balance -=1
```

#### async和 await

```py
import threading
import asyncio

async def hello():
    print('Hello world! (%s)' % threading.currentThread())
    await asyncio.sleep(1)
    print('Hello again! (%s)' % threading.currentThread())

loop = asyncio.get_event_loop()
tasks = [hello(), hello()]
loop.run_until_complete(asyncio.wait(tasks))
loop.close()
```

#### aiohttp(异步网络IO)

起一个flask服务
```py
from flask import Flask
import time
app = Flask(__name__)
@app.route('/<string:name>')
def index(name):
    # time.sleep(3)
    return "hello "+name
app.run(theraded=True)
```

用前面说的协程
```py
import asyncio
import requests
import time
start = time.time()
async def get(url):
    return requests.get(url)
async def request():
    url = 'http://127.0.0.1:5000/xiao'
    print('Waiting for', url)
    response = await get(url)
    print('Get response from', url, 'Result:', response.text)
 
tasks = [asyncio.ensure_future(request()) for _ in range(5)]
loop = asyncio.get_event_loop()
loop.run_until_complete(asyncio.wait(tasks))
end = time.time()
print('Cost time:', end - start)
```

用多线程
```py
import threading 
import requests
import time
start = time.time()
def get():
    res =requests.get("http://127.0.0.1:5000/xiao")
    print(res.text)
t =[]
for i in range(5):
    t.append(threading.Thread(target=get))
for i in t:
    i.start()
for i in t:
    i.join()
print(time.time()-start)
```
用多进程
```py
from multiprocessing import Pool
import time
import requests
start = time.time()
def get():
    res =requests.get("http://127.0.0.1:5000/xiao")
    print(res.text)
p = Pool(5)
for i in range(5):
    p.apply_async(get)
p.close()
p.join()
print(time.time()-start)
```


用aiohttp模块
```py
import aiohttp
import asyncio
import time
start_time = time.time()
async def fetch(session, url):
    async with session.get(url) as response:
        return await response.text()

async def main():
    async with aiohttp.ClientSession() as session:
        html = await fetch(session, 'http://127.0.0.1:5000/xiao')
        print(html)

loop = asyncio.get_event_loop()
tasks = [asyncio.ensure_future(main()) for _ in range(5)]
loop.run_until_complete(asyncio.wait(tasks))
print(time.time()-start_time)
```




参考链接
* https://cuiqingcai.com/6160.html
* https://aiohttp.readthedocs.io/en/stable