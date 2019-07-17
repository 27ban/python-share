#### 什么是链表

链表:是一种线性表，但是并不会按线性的顺序存储数据，在每一个节点里存到下一个节点的指针

![](\images\nodelist.png)

为什么要用链表，或者应用场景是哪？
链表的用处是在特定应用场景下省时间，比如数组在任意位置插入和删除是O(n)的，但链表是O(1)的


#### 设计链表
1. 设计节点
```py
class Node(object):
    def __init__(self,val):
        self.val = val
        self.next = None
```
2. 创建链表
```py
class NodeList(object):
    def __init__(self):
        self.head = None
    def add(self,val):
        node = Node(val)
        node.next =self.head
        self.head = node

    def search(self,item):
        head = self.head
        found = False
        while head.next != None and not found:
            if head.val == item:
                found = True
            head = head.next
        return found

    def size(self):
        size = 0
        head = self.head
        while head:
            size +=1
            head = head.next
        return size
    
    def toprint(self):
        head = self.head
        while head:
            print(head.val)
            head = head.next    
```

#### 链表常用操作

* 反转链表
```py
def reverseList(head):
    if not head or not head.next:
        return head
    node = reverseList(head.next)
    head.next.next = head
    head.next = None
    return node
```
* 链表排序

```py
# 归并排序，时间复杂度为O(nlogn)
def sortList(head):
    if(head is None or head.next is None):
        return head
    pre=head
    slow=head
    fast=head
    while(fast!=None and fast.next!=None):
        pre=slow
        slow=slow.next
        fast=fast.next.next
    left=head
    right=pre.next
    pre.next=None
    left=sortList(left)
    right=sortList(right)
    return merge(left,right)
    
def merge(left,right):
    head=Node(0)
    pre=head
    while(left and right):
        if(left.val<right.val):
            pre.next=left
            pre=left
            left=left.next
        else:
            pre.next=right
            pre=right
            right=right.next
    if(left is None):
        pre.next=right
    else:
        pre.next=left
    return head.next
```
更多链表相关信息(https://leetcode-cn.com/tag/linked-list)