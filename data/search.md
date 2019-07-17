#### 搜索
在一个集合中找特定项，找到返回True,否则返回False

* 顺序
```py
def search(alist,item):
    found = False
    index = 0
    while index<len(alist) and not found:
        if alist[index] == item:
            found =True
        else:
            index +=1
    return found
alist = [5,2,10,28,6]
print(search(alist,6))
```
* 二分查找
```py
# 首先想到的写法
def binarySearch(alist,item):
    first = 0
    last = len(alist)-1
    found = False
    while first<last and not found:
        mid = (first+last)//2
        if alist[mid] == item:
            found = True
        else:
            if item <alist[mid]:
                last = mid-1
            else:
                first = mid+1
    return found
alist = [5,9,12,15,25,37,48]
print(binarySearch(alist,37))
```
```py
# 递归写法
def binarySearch(alist,item):
    if len(alist) == 0:
        return False
    else:
        mid = len(alist)//2
        if item == alist[mid]:
            return True
        else:
            if item<alist[mid]:
                return binarySearch(alist[:mid],item)
            else:
                return binarySearch(alist[mid+1:],item)
alist = [5,9,12,15,25,37,48]
print(binarySearch(alist,37))
```
* Hash表
还没搞明白