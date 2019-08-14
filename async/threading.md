### 多线程

线程是最小的执行单元，一个进程由至少一个线程组成

```py
import threading
def loop():
    n = 0
    while n<5:
        n +=1
        # 线程名字
        print(threading.current_thread().name,n)
print(threading.current_thread().name)
t = threading.Thread(target=loop,name="Loop")
t.start()
t.join()
```

#### 多线程与多核 CPU

```py
import threading,multiprocessing
def loop():
	x = 0
	while True:
		x +=2
for i in range(multiprocessing.cpu_count()):
	t = threading.Thread(target=loop)
	t.start()
```

发现多线程只在单个 CPU 上执行。为什么不能充分利用多核 CPU 呢？

#### GIL(全局解释锁)

Python 执行过程

写在源文件中的代码都是为了人类可读，机器根本不知道他是什么鬼，所以需要转化为机器认识的，这个过程就是编译。
python 同样也有编译的步骤，通常 python 把.py 源文件编译成.pyc 类型的字节码文件,和 CPU 指令类似，但是这个.pyc 并不被 cpu 执行，而是由 python 虚拟机执行，这里的 python 虚拟机就是所说的 python 解释器。

用的最多的解释器 Cpython 解释器，因为是用 C 语言写的。设计之初，为了数据安全，加了锁。这个锁就是 GIL

单个线程的执行步骤:

- 获取 GIL
- 执行代码
- 释放 GIL 锁

由于有 GIL 锁的存在，python 一个进程里永远只能有一个线程在执行，这个线程就是抢到 GIL 锁的线程，不然就等待 GIL 锁的释放。每次 GIL 的释放，线程就各种锁竞争、切换。所以 python 中的多线程并不是真正的多线程。

#### 多线程中 Join 的用法

##### 默认情况

```py
import threading,time
def run():
	time.sleep(2)
	print(threading.current_thread().name)
start_time = time.time()
print(threading.current_thread().name)
thread_list = []
for i in range(4):
	thread_list.append(threading.Thread(target=run))
for t in thread_list:
	t.start()
print('Main End',threading.current_thread().name)
print(time.time()-start_time)
```

主线程结束，子线程继续执行自己的任务，直到全部线程执行结束，程序才结束。

##### 设置守护线程

```py
import threading,time
def run():
	time.sleep(2)
	print(threading.current_thread().name)
start_time = time.time()
print(threading.current_thread().name)
thread_list = []
for i in range(4):
	thread_list.append(threading.Thread(target=run))
for t in thread_list:
	t.setDaemon(True)
	t.start()
print('Main End',threading.current_thread().name)
print(time.time()-start_time)
```

主线程结束,程序结束，子线程还没来得及执行

##### Join 的用法

```py
import threading,time
def run():
	time.sleep(2)
	print(threading.current_thread().name)
start_time = time.time()
print(threading.current_thread().name)
thread_list = []
for i in range(4):
	thread_list.append(threading.Thread(target=run))
for t in thread_list:
	t.start()
for t in thread_list:
	t.join()
print('Main End',threading.current_thread().name)
print(time.time()-start_time)
```

主线程一直等待全部的子线程结束，主线程才结束，程序退出。

#### 线程同步

```py
import time,threading
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
```

多个线程同时读变量进行读写操作，就会导致变量异常，因为线程之间不是同步的，所以是需要线程同步。

##### 线程锁 Lock

```py
import time,threading
balance = 0
def change_it(n):
	global balance
	lock.acquire()
	balance +=n
	balance -=n
	lock.release()
def run_thread(n):
	for _ in range(1000000):
		change_it(n)
lock = threading.Lock()
t1 = threading.Thread(target=run_thread,args=(5,))
t2 = threading.Thread(target=run_thread,args=(8,))
t1.start()
t2.start()
t1.join()
t2.join()
print(balance)
```

##### 线程优先级队列(queue)

```py
from queue import Queue
import threading
import time
exitFlag = 0
class myThread (threading.Thread):
    def __init__(self, threadID, name, q):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.q = q
    def run(self):
        print ("Starting " + self.name)
        process_data(self.name, self.q)
        print ("Exiting " + self.name)
def process_data(threadName, q):
    while not exitFlag:
        if not workQueue.empty():
            data = q.get()
            print ("%s processing %s" % (threadName, data))
threadList = ["Thread-1", "Thread-2", "Thread-3"]
nameList = ["One", "Two", "Three", "Four", "Five"]
queueLock = threading.Lock()
workQueue = Queue(10)
threads = []
threadID = 1
# 创建新线程
for tName in threadList:
    thread = myThread(threadID, tName, workQueue)
    thread.start()
    threads.append(thread)
    threadID += 1
# 填充队列
for word in nameList:
    workQueue.put(word)
# 等待队列清空
while not workQueue.empty():
    pass
# 通知线程是时候退出
exitFlag = 1
# 等待所有线程完成
for t in threads:
    t.join()
print ("Exiting Main Thread")
```
