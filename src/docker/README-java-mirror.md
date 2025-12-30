# Java Docker 镜像国内替代方案aaa

## 问题说明

`openjdk:8-jre` 镜像在国内拉取可能较慢，需要找到可用的替代方案。

## 推荐方案

### 方案一：使用 eclipse-temurin（推荐）⭐

**eclipse-temurin** 是 AdoptOpenJDK 的后续项目，由 Eclipse 基金会维护，提供长期支持。

**优势：**
- 官方维护，更新及时
- 提供安全补丁
- 项目中的 auth、gateway、system 模块已在使用
- 国内镜像源支持较好

**镜像地址：**
```dockerfile
FROM eclipse-temurin:8-jre
# 或指定具体版本
FROM eclipse-temurin:8u382-b05-jre
```

**国内镜像源：**
- 阿里云：`registry.cn-hangzhou.aliyuncs.com/library/eclipse-temurin:8-jre`
- 腾讯云：`ccr.ccs.tencentyun.com/library/eclipse-temurin:8-jre`

### 方案二：使用国内镜像仓库的 openjdk

#### 阿里云镜像仓库
```dockerfile
FROM registry.cn-hangzhou.aliyuncs.com/library/openjdk:8-jre
```

#### 腾讯云镜像仓库
```dockerfile
FROM ccr.ccs.tencentyun.com/library/openjdk:8-jre
```

#### 网易镜像仓库
```dockerfile
FROM hub.c.163.com/library/openjdk:8-jre
```

### 方案三：配置 Docker 镜像加速（拉取原始镜像）

如果希望继续使用 `openjdk:8-jre`，可以配置 Docker 镜像加速来加速拉取。

创建或编辑 `/etc/docker/daemon.json`：
```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

然后重启 Docker：
```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 项目中的使用情况

### 当前使用 openjdk:8-jre 的文件：
- `src/docker/ruoyi/visual/monitor/dockerfile`
- `src/docker/ruoyi/modules/job/dockerfile`
- `src/docker/ruoyi/modules/gen/dockerfile`
- `src/docker/ruoyi/modules/file/dockerfile`

### 已使用 eclipse-temurin 的文件：
- `src/docker/ruoyi/auth/dockerfile` - `eclipse-temurin:8u382-b05-jre`
- `src/docker/ruoyi/gateway/dockerfile` - `eclipse-temurin:8u382-b05-jre`
- `src/docker/ruoyi/modules/system/dockerfile` - `eclipse-temurin:8u382-b05-jre`

## 建议

**推荐统一使用 `eclipse-temurin:8-jre`**，原因：
1. 项目已有部分模块在使用，保持一致性
2. 官方维护，更可靠
3. 提供安全更新
4. 国内镜像支持良好

## 快速替换命令

如果需要批量替换项目中的 `openjdk:8-jre` 为 `eclipse-temurin:8-jre`：

```bash
# 在 src/docker 目录下执行
find . -name "dockerfile" -type f -exec sed -i 's|FROM.*openjdk:8-jre|FROM eclipse-temurin:8-jre|g' {} \;
```

