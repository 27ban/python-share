### 同步与异步

### 多线程
线程是最小的执行单元，一个进程由至少一个线程组成，这个线程加主线程
```py
import threading
def loop():
    n = 0
    while n<5:
        n +=1
        print(threading.current_thread().name,n)
t = threading.Thread(target=loop,name="Loop")
t.start()
t.join()
```
### 多进程

### 协程

