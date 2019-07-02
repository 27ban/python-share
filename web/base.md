### WSGI
web应用的本质: 浏览器发HTTP请求-->服务器接收请求，生成HTML-->服务器把HTTP响应给浏览器-->浏览器接收HTTP响应，并展示HTML文档
然后接收HTTP请求，解析HTTP请求，响应HTTP请求，都是很复杂的，首先要熟悉HTTP规范。然后才能再此基础上写业务逻辑，这样费时费力，我们不希望接触到TCP连接、HTTP原始请求和响应格式，所以是需要有一个专门的软件实现，提供接口供我们调用。这个接口就是WSGI
wsgiref就是python自带的web服务器

### wsgiref模块

#### 简单起个服务
```py
from wsgiref.simple_server import make_server
def app(environ,start_response):
    start_response('200 OK',[('Content-Type','text/html')])
    return [b'<h1>Hello, web!</h1>']
httpd  = make_server('',8000,app)
# serve_forever 起一个wsgi服务器
httpd.serve_forever()
```

#### WSGI服务器是如何启动的
先看一下wsgiref/simple_server.py 里面有什么
```py
from http.server import BaseHTTPRequestHandler, HTTPServer
from wsgiref.handlers import SimpleHandler
# 继承HTTPServer,最后调用的serve_forever就是父类的方法   
class WSGIServer(HTTPServer):
    application = None
    def server_bind(self):
        HTTPServer.server_bind(self)
        self.setup_environ()
    def setup_environ(self):
        env = self.base_environ = {}
        env['SERVER_NAME'] = self.server_name
        env['GATEWAY_INTERFACE'] = 'CGI/1.1'
        env['SERVER_PORT'] = str(self.server_port)
        env['REMOTE_HOST']=''
        env['CONTENT_LENGTH']=''
        env['SCRIPT_NAME'] = ''
    def set_app(self,application):
        self.application = application

# 处理request请求的类，继承与base的request类
class WSGIRequestHandler(BaseHTTPRequestHandler):
    # 设置env环境变量字典并返回
    def get_environ(self):
        env = self.server.base_environ.copy()
        env['SERVER_PROTOCOL'] = self.request_version
        env['SERVER_SOFTWARE'] = self.server_version
        env['REQUEST_METHOD'] = self.command
        for k, v in self.headers.items():
            k=k.replace('-','_').upper(); v=v.strip()
            if k in env:
                continue                   
            if 'HTTP_'+k in env:
                env['HTTP_'+k] += ','+v     
            else:
                env['HTTP_'+k] = v
        return env
    # 处理request请求的主要步骤
    def handle(self):
        self.raw_requestline = self.rfile.readline(65537)
        # 相遇与实例化SimpleHandler执行类他的run方法
        handler = SimpleHandler(self.rfile, self.wfile, self.get_stderr(), self.get_environ())
        handler.request_handler = self
        handler.run(self.server.get_app())

def make_server(host, port, app, server_class=WSGIServer, handler_class=WSGIRequestHandler):
    # 实例化WSGIServer
    # handler_class 处理request请求的类
    server = server_class((host, port), handler_class)
    server.set_app(app)
    return server
```

htttp/server.py
```py
import http.client
import socketserver
class HTTPServer(socketserver.TCPServer):
    allow_reuse_address = 1 
    def server_bind(self):
        socketserver.TCPServer.server_bind(self)
        host, port = self.server_address[:2]
        self.server_name = socket.getfqdn(host)
        self.server_port = port
```

socketserver.py
```py
'''
        +------------+
        | BaseServer |
        +------------+
              |
              v
        +-----------+        +------------------+
        | TCPServer |------->| UnixStreamServer |
        +-----------+        +------------------+
              |
              v
        +-----------+        +--------------------+
        | UDPServer |------->| UnixDatagramServer |
        +-----------+        +--------------------+
'''
class BaseServer:
    def __init__(self, server_address, RequestHandlerClass):
        self.server_address = server_address
        self.RequestHandlerClass = RequestHandlerClass
    def serve_forever(self, poll_interval=0.5):
        self.__is_shut_down.clear()
        try:
            with _ServerSelector() as selector:
                selector.register(self, selectors.EVENT_READ)
                # 每隔0.5秒轮询一次是否有请求进来，如果有就执行self._handle_request_noblock()方法
                while not self.__shutdown_request:
                    ready = selector.select(poll_interval)
                    if ready:
                        self._handle_request_noblock()
                    self.service_actions()
        finally:
            self.__shutdown_request = False
            self.__is_shut_down.set()

    def _handle_request_noblock(self):
        try:
            request, client_address = self.get_request()
        except OSError:
            return
        if self.verify_request(request, client_address):
            try:
                self.process_request(request, client_address)
            except Exception:
                self.handle_error(request, client_address)
                self.shutdown_request(request)
            except:
                self.shutdown_request(request)
                raise
        else:
            self.shutdown_request(request)

    # 分2步，1.完成request请求，发送数据给客户端，2.关闭连接
    def process_request(self, request, client_address):
        self.finish_request(request, client_address)
        self.shutdown_request(request)

    # 调用该方法完成request请求
    def finish_request(self, request, client_address):
        # 这里实际上就是wsgiref/simple_server.py的 WSGIRequestHandler
        self.RequestHandlerClass(request, client_address, self)
    
class TCPServer(BaseServer):
    def get_request(self):
        return self.socket.accept()
    def shutdown_request(self, request):
        try:
            request.shutdown(socket.SHUT_WR)
        except OSError:
            pass #some platforms may raise ENOTCONN here
        self.close_request(request)
    def close_request(self, request):
        request.close()
```
WSGI服务器大概启动过程，先执行wsgiref的make_server，返回实例化的WSGIServer，WSGIServer继承与socketserver.py的TCPServer类，而TCPserver继承与BaseServer类，最后执行的serve_forever相当于就是BaseServer的serve_forever的方法,该方法就是创建一个死循环，一直监听是否有请求进来，如果有就执行self.process_request处理request

##### wsgiref处理request

http/server.py
```py
class BaseHTTPRequestHandler(socketserver.StreamRequestHandler):
    pass
```
socketserver.py
```py
# 处理request请求的Base类，相当于调用了self.handle的方法
class BaseRequestHandler:
    def __init__(self, request, client_address, server):
        self.request = request
        self.client_address = client_address
        self.server = server
        try:
            self.handle()
        finally:
            self.finish()
    def handle(self):
        pass

    def finish(self):
        pass
class StreamRequestHandler(BaseRequestHandler):
    pass
```

上面说了实现处理request的是WSGIRequestHandler,而他继承了BaseRequestHandler，并重写了handle方法，当wsgi服务器接收到一个有请求过来时就会实例化一次WSGIRequestHandler，实例化时就会执行他的handler方法。handle实例化SimpleHandler并执行run方法.

```py
from wsgiref.handlers import SimpleHandler
def handle(self):
    self.raw_requestline = self.rfile.readline(65537)
    # 相当与实例化SimpleHandler执行类他的run方法
    handler = SimpleHandler(self.rfile, self.wfile, self.get_stderr(), self.get_environ())
    handler.request_handler = self
    handler.run(self.server.get_app())
```

wsgiref/handlers
```py
class BaseHandler:
    # 分3步
    # 1建立环境变量字典environ
    # 2.设置状态吗和headers并返回response的body
    # 3.将response返回给客户端
    def run(self, application):
        try:
            self.setup_environ()
            self.result = application(self.environ, self.start_response)
            self.finish_response()
        except:
            try:
                self.handle_error()
            except:
                self.close()
                raise
    def finish_response(self):
        try:
            if not self.result_is_file() or not self.sendfile():
                for data in self.result:
                    self.write(data)
                self.finish_content()
        finally:
            self.close()

    def finish_content(self):
        if not self.headers_sent:
            self.headers.setdefault('Content-Length', "0")
            self.send_headers()
        else:
            pass
    def start_response(self, status, headers,exc_info=None):
        self.status = status
        self.headers = self.headers_class(headers)
        status = self._convert_string_type(status, "Status")
        return self.write

    def send_headers(self):
        self.cleanup_headers()
        self.headers_sent = True
        if not self.origin_server or self.client_is_modern():
            self.send_preamble()
            self._write(bytes(self.headers))

    def write(self, data):
        if not self.status:
            raise AssertionError("write() before start_response()")
        elif not self.headers_sent:
            self.bytes_sent = len(data)
            self.send_headers()
        else:
            self.bytes_sent += len(data)
        self._write(data)
        self._flush()

    def send_preamble(self):
        if self.origin_server:
            if self.client_is_modern():
                self._write(('HTTP/%s %s\r\n' % (self.http_version,self.status)).encode('iso-8859-1))
        else:
            self._write(('Status: %s\r\n' % self.status).encode('iso-8859-1'))
    def close(self):
        try:
            if hasattr(self.result,'close'):
                self.result.close()
        finally:
            self.result = self.headers = self.status = self.environ = None
            self.bytes_sent = 0; self.headers_sent = False

class SimpleHandler(BaseHandler):
    def _write(self,data):
        result = self.stdout.write(data)
        while True:
            data = data[result:]
            if not data:
                break
            result = self.stdout.write(data)

    def _flush(self):
        self.stdout.flush()
        self._flush = self.stdout.flush
```
flask和django都用到了wsgiref模块，django是直接调用的，flask是间接调用的，由于对性能的需求，wsgiref很少用于线上环境，线上一般用nginx+gunicorn+flask搭配使用。
wsgiref设计时wsgi 服务器和wsgi app 是分开的，也就是说我们在部署项目的时候可以不用自带的wsgi sever，使用python web的开发也是很灵活的。不同的wsgi server 的区别在于多线程、多进程、协程。而wsgi app通常就是根据请求的路由不同，执行不同的view视图函数。
