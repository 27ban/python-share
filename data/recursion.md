### 递归
给定一个n,怎么求斐波那契数列第n项的值？
```py
def fin(n):
    if n<=1:
        return n
    return fin(n-1)+fin(n-2)
```
由于知道第n项是n-1和n-2的和，n-1是n-1-1和n-1-2的和，一直往后推，上面就是一个简单的递归。

递归的核心思想是把一个大而复杂的问题，分成一些小而简单的问题，通过解决这些小问题来解决一个大问题。

递归有一些特殊的规律
* 最基本情况或最小情况
* 必须有改变状态的控制语句让其往基本情况靠近
* 递归调用本身


货币找零问题
coins = [1,5,10,25], 找零63，可以用来找零的最小数量的硬币是多少？
### 贪心算法(着眼于当下，局部最优化)

```py
v = [25,10,5,1]
n = [0]*len(v)
def greedy(T):
    if T==0:
        return
    elif T>=v[0]:
        T=T-v[0]; n[0]=n[0]+1
        greedy(T)
    elif v[0]>T>=v[1]:
        T=T-v[1]; n[1]=n[1]+1
        greedy(T)
    elif v[1]>T>=v[2]:
        T=T-v[2]; n[2]=n[2]+1
        greedy(T)
    else:
        T=T-v[3]; n[3]=n[3]+1
        greedy(T)
greedy(63)
print(sum(n))
```

### 动态规划(全局最优化)


```py
def recMC(coinValueList,change):
   minCoins = change
   if change in coinValueList:
     return 1
   else:
      for i in [c for c in coinValueList if c <= change]:
         numCoins = 1 + recMC(coinValueList,change-i)
         if numCoins < minCoins:
            minCoins = numCoins
   return minCoins
print(recMC([1,5,10,25],63))
```
