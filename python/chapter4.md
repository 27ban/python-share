### python练习题

* 在屏幕上显示跑马灯文字
```py
import os
import time
def marquee():
    content = '北京欢迎你为你开天辟地…………'
    while True:
        os.system('clear')
        print(content)
        time.sleep(0.2)
        content = content[1:] + content[0]
marquee()
```
* 设计一个函数产生指定长度的验证码，验证码由大小写字母和数字构成。
```py
import random
import string
def captcha(n=4):
    source = list(string.ascii_letters)
    source.extend(map(lambda x: str(x), range(0, 10)))
    return  "".join(random.sample(source, n))
print(captcha(6))
```
* 计算指定的年月日是这一年的第几天
```py
def is_leap_year(year):
    return year % 4 == 0 and year % 100 != 0 or year % 400 == 0
def which_day(year, month, date):
    days_of_month = [
        [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
        [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    ][is_leap_year(year)]
    total = 0
    for index in range(month - 1):
        total += days_of_month[index]
    return total + date
print(which_day(2019,12,31))
import pandas as pd
def which_day2(s):
    d = pd.to_datetime(s,"coerce")
    if str(d)=='NaT':
        return ""
    return d.dayofyear
print(which_day2('2019-12-12'))
```
* 设计一个函数返回给定文件名的后缀名。
```py
def get_filename(name):
    res = name.rsplit(".",1)
    return "" if len(res)==1 else res[-1]
name="helrkjelr.xls"
print(get_filename(name))
```
* 设计一个函数返回时针与分针的夹角。
```py
def times(h,m):
    return abs(((h+m//12)*5-m)*6)
```
* 有效括号
```py
#给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。
#有效字符串需满足：
#    左括号必须用相同类型的右括号闭合。
#    左括号必须以正确的顺序闭合。
#    注意空字符串可被认为是有效字符串。
def isValid1(s):
    d = {')':'(',']':'[','}':'{'}
    stack = [None]
    for i in s:
        if i in d and d[i]==stack[-1]:
            stack.pop()
        else:
            stack.append(i)
    return len(stack)==1
s = "()()()"
print(isValid1(s))
def isValid2(s):
    while '{}' in s or '()' in s or '[]' in s:
            s = s.replace('{}', '')
            s = s.replace('[]', '')
            s = s.replace('()', '')
    return s == ''
```




面向对象编程
* 定义一个类描述平面上的点并提供移动点和计算到另一个点距离的方法。
```py
from math import sqrt
class Point(object):
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y
    def move_to(self, x, y):
        self.x = x
        self.y = y
    def move_by(self, dx, dy):
        self.x += dx
        self.y += dy
    def distance_to(self, other):
        dx = self.x - other.x
        dy = self.y - other.y
        return sqrt(dx ** 2 + dy ** 2)
    def __str__(self):
        return '(%s, %s)' % (str(self.x), str(self.y))
p1 = Point(3, 5)
p2 = Point()
print(p1)
print(p2)
p2.move_by(-1, 2)
print(p2)
print(p1.distance_to(p2))
```
* 工资结算系统
```py
# 某公司有三种类型的员工 分别是部门经理、程序员和销售员需要设计一个工资结算系统 
# 根据提供的员工信息来计算月薪
# 部门经理的月薪是每月固定15000元
# 程序员的月薪按本月工作时间计算 每小时150元
# 销售员的月薪是1200元的底薪加上销售额5%的提成
class Employee(object):
    def __init__(self,name):
        self._name = name
    def name(self):
        return self._name
    def get_salary(self):
        pass
class Manager(Employee):
    def get_salary(self):
        return 15000.0
class Programmer(Employee):
    def __init__(self,name,hour=0):
        super().__init__(name)
        self._working_hour = hour
    def working_hour(self,hour):
        self._working_hour = hour
    def get_salary(self):
        return 150.0*self._working_hour
class Salesman(Employee):
    def __init__(self,name,sales=0):
        super().__init__(name)
        self._sales = sales
    def sales(self,sales):
        self._sales = sales
    def get_salary(self):
        return 1200.0 +self._sales*0.05
emps = [Manager('a'),Programmer('b'),Salesman('c')]
for emp in emps:
    if isinstance(emp,Programmer):
        emp.working_hour(int(input('%s'% emp.name())))
    elif isinstance(emp,Salesman):
        emp.sales(float(input('%s'% emp.name())))
    print(emp.name(),emp.get_salary())
```
