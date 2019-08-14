#### 多进程

Join 用法同多线程一样

```py
import os
from multiprocessing import Process
def run_pro(num):
    print(os.getpid(),num)

print("Main Process",os.getpid())
p_list = []
for i in range(4):
    p_list.append(Process(target=run_pro,args=(i,)))
for p in p_list:
    # p.daemon = False
    p.start()
for p in p_list:
    p.join()
print("Main Process",os.getpid())
```

#### 进程池 Pool

```py
from multiprocessing import Pool
import os
def run_pro(num):
    print(os.getpid(),num)
print(os.getpid(),"Main process")
p = Pool()
for i in range(5):
    # p.apply(run_pro,args=(i,))
    p.apply_async(run_pro,args=(i,))
p.close()
p.join()
print("Main Process")
```

Pool 由两种模式，阻塞和非阻塞，阻塞即添加进程后必须等待前面的进程执行结束才执行，非阻塞则相反。

#### 多进程通信

##### 多进程锁 Lock

```py
from multiprocessing import Process, Lock
import time
class MyProcess(Process):
    def __init__(self, loop, lock):
        Process.__init__(self)
        self.loop = loop
        self.lock = lock
    def run(self):
        for count in range(self.loop):
            time.sleep(0.1)
            self.lock.acquire()
            print('Pid: ' + str(self.pid) + ' LoopCount: ' + str(count))
            self.lock.release()
lock = Lock()
for i in range(10, 15):
    p = MyProcess(i, lock)
    p.start()
```

##### Queue 队列

```py
from multiprocessing import Process,Queue
import time
buffer = Queue(10)
class Producer(Process):
    def run(self):
        global buffer
        for num in range(5):
            print("Producer",num)
            buffer.put(num)
            time.sleep(2)
class Consumer(Process):
    def run(self):
        global buffer
        while True:
            print("Consumer",buffer.get())
            time.sleep(2)
p = Producer()
c = Consumer()
p.daemon = c.daemon = True
p.start()
c.start()
p.join()
# c进程里是死循环，无法等待其结束，只能强行终止
c.terminate()
```
