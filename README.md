# crictl

为 ansible-podman 项目准备可跨平台的 crictl 二进制文件。

## build

[crictl](https://github.com/kubernetes-sigs/cri-tools)

```bash
docker run -it --rm \
  -v $PWD/:/go/src/github.com/open-beagle/cri-tools \
  -w /go/src/github.com/open-beagle/cri-tools \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.22 \
  bash src/build.sh
```

## deploy

```bash
docker run -it --rm \
  -v /etc/kubernetes/downloads:/etc/kubernetes/downloads \
  registry.cn-qingdao.aliyuncs.com/wod/cri-tools:v1.31.1 \
  cp /bin/crictl /etc/kubernetes/downloads/crictl-linux-v1.31.1 && \
mkdir -p /opt/bin && \
ln -s /etc/kubernetes/downloads/crictl-linux-v1.31.1 /opt/bin/crictl && \
chmod +x /etc/kubernetes/downloads/crictl-linux-v1.31.1
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="cri-tools" \
  -e PLUGIN_MOUNT="./.git,./.tmp" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="cri-tools" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
