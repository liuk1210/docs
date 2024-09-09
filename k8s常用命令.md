### 部署镜像
~~~
kubectl create deployment 应用名称 --image=镜像 --port=暴露端口
~~~
### 查看所有pod
~~~
kubectl get pods -o wide -A
~~~
### 根据命名空间查找pod
~~~
kubectl get pods -o wide -n [命名空间]
~~~
### 查看pod描述
~~~
kubectl describe pod [pod名称] -n [命名空间]
~~~
### 查看pod日志
~~~
kubectl logs [pod名称] -n [命名空间]
~~~
## 导出yaml文件
~~~
kubectl create deployment 应用名称 --image=nginx --dry-run -o yaml > web.yaml
1.19.3版本中 --dry-run=client
~~~
## 对外暴露端口
~~~
kubectl expose deployment 应用名称 --port=80 --type=NodePort --name=web1 

kubectl expose deployment nginx --port=80 --target-port=8000
~~~
## 应用升级
~~~
kubectl set image deployment 应用名称 镜像名称：镜像名称：版本号
~~~
## 查看升级状态
~~~
kubectl rollout status deployment 应用名称
~~~
## 查看升级版本
~~~
kubectl rollout history deployment 应用名称
~~~
## 回滚到上一个版本
~~~
kubectl rollout undo deployment 应用名称
--to-revision=2 指定版本
~~~
## 弹性伸缩
~~~
kubectl scale deployment 应用名称 --replicas=10
~~~