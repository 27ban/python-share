### 递归

给定一个 n,怎么求斐波那契数列第 n 项的值？

```py
def fin(n):
    if n<=1:
        return n
    return fin(n-1)+fin(n-2)
```

由于知道第 n 项是 n-1 和 n-2 的和，n-1 是 n-1-1 和 n-1-2 的和，一直往后推，上面就是一个简单的递归。

递归的核心思想是把一个大而复杂的问题，分成一些小而简单的问题，通过解决这些小问题来解决一个大问题。

递归有一些特殊的规律

- 最基本情况或最小情况
- 必须有改变状态的控制语句让其往基本情况靠近
- 递归调用本身

货币找零问题
coins = [1,5,10,25], 找零 63，可以用来找零的最小数量的硬币是多少？

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

怎么理解:
不仅仅是把大问题切成小问题,还需要保存每一步的计算结果,因为下一步要用

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

运行很慢，代码还待优化

### 优化

```py
def dpMakeChange(coinValueList,change,minCoins,coinsUsed):
   for cents in range(change+1):
      coinCount = cents
      newCoin = 1
      for j in [c for c in coinValueList if c <= cents]:
            if minCoins[cents-j] + 1 < coinCount:
               coinCount = minCoins[cents-j]+1
               newCoin = j
      minCoins[cents] = coinCount
      coinsUsed[cents] = newCoin
   return minCoins[change]

def printCoins(coinsUsed,change):
   coin = change
   while coin > 0:
      thisCoin = coinsUsed[coin]
      print(thisCoin)
      coin = coin - thisCoin

def main():
    amnt = 63
    clist = [1,5,10,21,25]
    coinsUsed = [0]*(amnt+1)
    coinCount = [0]*(amnt+1)
    print("Making change for",amnt,"requires")
    print(dpMakeChange(clist,amnt,coinCount,coinsUsed),"coins")
    print("They are:")
    printCoins(coinsUsed,amnt)
    print("The used list is as follows:")
    print(coinsUsed)
```
