#### Tornado
相对Django来说，性能好，其实现原理和flask，Django不太一样，不是wsgi,而是IO多路复用。

##### 网络IO多路复用
传统的轮询socket连接，只要一个socket连接阻塞就会导致整个应用阻塞。
- select方式
工作方式：将每个socket对象存入一个列表里，然后轮询，对可读写的对象进行读写，当有新的连接需要监控或者处理时，重新进行轮询
缺点：1。单个进程通过轮询的方式来监控，为保证效率，有上限，32位是1024
    2。效率低，轮询所有的socket对象，依次来检查是否可操作，这种逐个排查的方式效率太低
- poll方式：本质与select没有什么区别，只是将socket对象的列表，变成了链表，解决了上限的问题，效率低并没有解决
- epoll方式（tornado核心）：其整个流程和select，poll差不多，主要解决了效率低的问题
epoll为每个socket对象注册一个回调函数，当socket对象状态发生变更时，将该对象加入固定的链表，只需要改链表的socket对象即可。

tornado采用的就是epoll方式，所以说性能比较高，实现了一个进程/线程来处理成千上万的连接，解决了著名的C10K的问题

##### Web框架
```python
from tornado.web import Application, RequestHandler
from tornado.ioloop import IOLoop
from tornado.gen import coroutine


class IndexHandler(RequestHandler):
    # @coroutine
    def get(self, *args, **kwargs):
        self.write('hello world')

app = Application([
    (r'/', IndexHandler)
])        
app.listen(5050)
IOLoop.instance().start()

```
实际上还是同步阻塞的
通过添加装饰器@coroutine变成异步的


##### 异步和协程


##### 异步网络库


- 异步请求客户端AsyncHTTPClient
```python
from tornado.httpclient import AsyncHTTPClient, HTTPResponse
from tornado.ioloop import IOLoop
from tornado.gen import coroutine, Return

@coroutine
def async_fetch() -> HTTPResponse:
    client = AsyncHTTPClient()
    future = yield client.fetch('http://wwww.baidu.com')
    return future
    # raise Return(future)

response = IOLoop.current().run_sync(async_fetch)
print(response)

```
run_sync 可以自动开启 ioloop 并在函数执行结束之后关闭 ioloop


- 异步并行
```python
from tornado.httpclient import AsyncHTTPClient
from tornado.ioloop import IOLoop
from tornado.gen import coroutine

@coroutine
def async_fetch():
    client = AsyncHTTPClient()
    urls = ['http://www.baidu.com'] * 20
    future = yield [client.fetch(url) for url in urls]
    return future

responses = IOLoop.current().run_sync(async_fetch)
print(responses)
```
