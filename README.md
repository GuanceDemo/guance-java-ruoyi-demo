# guance-java-ruoyi-demo
> 项目来源：[Ruoyi-Cloud](https://gitee.com/y_project/RuoYi-Cloud)

[观测云](https://www.guance.com/)是一款旨在解决云计算，以及云原生时代系统为每一个完整的应用构建全链路的可观测性的云服务平台。本项目通过接入若依管理系统，让您快速了解 Java 服务接入观测云的流程以及体验完整的全链路可观测性。

***

## 前提条件
[安装 DataKit Operator 和 DataKit](https://github.com/GuanceDemo/guance-datakit-demo)

***

## 方式一：Helm方式手动安装
> 通过 Helm 安装至 Kubernetes 集群，适合快速安装 guance-java-ruoyi-demo 进行演示的场景。

### 1. 安装
#### 1.1 执行安装
```shell
git clone https://github.com/GuanceDemo/guance-java-ruoyi-demo.git
cd guance-java-ruoyi-demo
helm upgrade -i ruoyi -n ruoyi --create-namespace ./deployment/helm
```
#### 1.2 terraform 创建观测云资源
[Terraform安装](https://www.terraform.io/downloads.html)

环境变量：
- `GUANCE_ACCESS_TOKEN`: 观测云 Key ID，创建方式：[API Key](https://docs.guance.com/management/api-key/)
- `GUANCE_REGION`: 观测云 region，可选项：[terraform-provider-guance](https://github.com/GuanceCloud/terraform-provider-guance)

```shell
cd guance-java-ruoyi-demo/terraform
export GUANCE_ACCESS_TOKEN=xxx
export GUANCE_REGION=xxx
terraform init
terraform plan
terraform apply -auto-approve 
```

#### 1.3 访问方式
部署完成后可通过 web-service 的 NodePort 方式进行访问，默认端口为 30001
```shell
kubectl get pod -n ruoyi -o wide
```

### 2. 卸载
#### 2.1 删除观测云资源
```shell
cd guance-java-ruoyi-demo/terraform
terraform destroy -auto-approve 
```
#### 2.2 卸载若依
```
helm unintall ruoyi -n ruoyi
```

***

## 方式二：自动化部署
> 通过 Github Action 自动打包并安装至 Kubernetes 集群，适合对 guance-java-ruoyi-demo 源码修改的场景。
 
### 1. fork 代码到自己的 Github 仓库

### 2. 创建并添加以下密钥和变量
> 创建路径：Settings --> Secrets and Variables --> Action  

New repository Secret
- `KUBECONFIG`: Kubernetes config文件，用于 Action 执行机远程操作 Kubernetes 集群
- `DOCKER_USERNAME`: 镜像仓库登陆用户名
- `DOCKER_PASSWORD`: 镜像仓库登陆密码
- `GUANCE_ACCESS_TOKEN`: 观测云 Key ID，创建方式：[API Key](https://docs.guance.com/management/api-key/)

New repository Variable
- `DOCKER_REGISTRY`: 镜像仓库地址，如 pubrepo.guance.com
- `DOCKER_NAMESPACE`: 镜像仓库项目名，如 demo
- `GUANCE_REGION`: 观测云 region，可选项：[terraform-provider-guance](https://github.com/GuanceCloud/terraform-provider-guance)

> 配置后镜像地址：$DOCKER_REGISTRY/$DOCKER_NAMESPACE/demo:latest


### 3. 触发自动打包流水线
> 手动触发路径：Action --> Build and push ruoyi ui demo images/Build and push ruoyi java demo images --> Run Workflow

自动打包流水线会自动打包若依的前端和后端镜像并推送至镜像仓库, 可通过修改 src 下任意文件或手动方式进行触发。

- `Build and push ruoyi ui demo images`: 前端 CI 流水线
- `Build and push ruoyi java demo images`: 后端 CI 流水线

### 4. 触发自动部署流水线 
自动部署流水线通过手动触发进行部署。
- `Deploy ruoyi demo on kubernetes`: CD 流水线

### 5. 触发 terraform 流水线
> 手动触发路径：Action --> Manage Guance resources using terraform --> Run Workflow

terraform 流水线会自动创建项目所需要的观测云资源，可通过修改 terraform 下任意文件或手动方式进行触发。
- `Manage Guance resources using terraform`: terraform 流水线

### 6. 访问方式
部署完成后可通过 web-service 的 NodePort 方式进行访问，默认端口为 30001
```shell
kubectl get pod -n ruoyi -o wide
```

### 7. 卸载
通过手动执行以下流水线进行卸载。
- `Manage Guance resources using terraform`: Run Workflow 时选择 destroy 进行卸载
- `Uninstall ruoyi demo on kubernetes`: 从 Kubernetes 集群删除