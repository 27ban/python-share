#### django

##### 中间件方法
process_request 请求进来时，常用权限认证
process_view 匹配路由后，准备执行view时
process_exceptiion 异常时执行
process_response 请求有相应时
process_template_responseprocess 模版渲染时执行

##### queryset常用操作
filter
get
all
count
reverse
order_by
first
last
values
values_list
exclude
distinct
select_related
prefetch_related


##### model加载方式
django默认采用懒加载的方式，只有在调用时才执行
- select_related一对多或者一对一

- prefetch_related多对多或者多对一

##### 如何设置自动更新
- auto_now每次save都进行更新

- auto_now_add只有在创建时更新

##### F对象和Q对象
- Q对象:组合多个查询条件

- F对象:将python操作映射成sql操作

##### 如何读写分离
- 手动操作(using)

- 自动(通过修改配置)


##### Django如何虚拟化model

```python
from django.db import models
class Base(models.Model):
    # ...
    class Meta:
        abstract = True

```

##### django-debug-toolbar调试工具
```python
# urls.py
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls import url
urlpatterns = [
    path('admin/', admin.site.urls),
    path('demo/', include('demo.urls'))
]
if settings.DEBUG:
    import debug_toolbar
    urlpatterns = [
        url(r'__debug__/', include(debug_toolbar.urls))
    ] + urlpatterns

```
```python
# settings.py
INSTALLED_APPS = [
    # ...
    'debug_toolbar',
    # ...
]

MIDDLEWARE = [
    # ...
    'debug_toolbar.middleware.DebugToolbarMiddleware',
    # ...
]
INTERNAL_IPS = ['127.0.0.1']

```

##### django与celery结合

这是一个小demo
[DEMO](https://github.com/27ban/django_learn)


#### django-rest-framework
1. 权限
2. 视图
3. 分页
4. 序列化
5. 访问限制


