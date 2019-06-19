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

```py
```