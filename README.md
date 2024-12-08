# docker-arch-test
使用 docker buildx 命令来创建和推送 list 测试多平台镜像推送一个tag。

![Watchers](https://img.shields.io/github/watchers/20241204/docker-arch-test) ![Stars](https://img.shields.io/github/stars/20241204/docker-arch-test) ![Forks](https://img.shields.io/github/forks/20241204/docker-arch-test) ![Vistors](https://visitor-badge.laobi.icu/badge?page_id=20241204.docker-arch-test) ![LICENSE](https://img.shields.io/badge/license-CC%20BY--SA%204.0-green.svg)
<a href="https://star-history.com/#20241204/docker-arch-test&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=20241204/docker-arch-test&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=20241204/docker-arch-test&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=20241204/docker-arch-test&type=Date" />
  </picture>
</a>

## ghcr.io
镜像仓库链接：[https://github.com/20241204/docker-arch-test/pkgs/container/docker-arch-test](https://github.com/20241204/docker-arch-test/pkgs/container/docker-arch-test)

## 描述
1.为了实现 actions workflow 自动化 docker 构建运行，需要添加 `GITHUB_TOKEN` 环境变量，这个是访问 GitHub API 的令牌，可以在 GitHub 主页，点击个人头像，Settings -> Developer settings -> Personal access tokens -> Tokens (classic) -> Generate new token -> Generate new token (classic) ，设置名字为 GITHUB_TOKEN 接着要配置 环境变量有效时间，勾选环境变量作用域 repo write:packages workflow 和 admin:repo_hook 即可，最后点击Generate token，如图所示
![image](assets/00.jpeg)
![image](assets/01.jpeg)
![image](assets/02.jpeg)
![image](assets/03.jpeg)  

2.赋予 actions[bot] 读/写仓库权限，在仓库中点击 Settings -> Actions -> General -> Workflow Permissions -> Read and write permissions -> save，如图所示
![image](assets/04.jpeg)

3.转到 Actions  

    -> Docker Image Build and Deploy Images to GHCR CI 并且启动 workflow，实现自动化构建镜像并推送云端  
    -> Clean Git Large Files 并且启动 workflow，实现自动化清理 .git 目录大文件记录  
    -> Remove Old Workflow Runs 并且启动 workflow，实现自动化清理 workflow 并保留最后三个  

## 通知 docker 使用 qemu 在 x86_64 CPU 上支持多架构编译
    docker run --platform linux/amd64 --privileged --rm tonistiigi/binfmt:master --install all

# 展示可支持的模拟架构
    docker run --privileged --rm tonistiigi/binfmt:master

# 安装并启用 buildx 插件
    docker buildx install

# 创建并使用一个新的构建器实例
    docker buildx create --use

## docker-arch-test 测试材料
    # docker-arch-test 目录结构
    .
    ├── arch-test.sh
    ├── docker-compose-amd64.yml
    ├── docker-compose-arm64.yml
    └── Dockerfile

## arch-test.sh 测试材料脚本内容
    #!/bin/ash
    uname -m
    uname -s

## docker-compose-amd64.yml 内容
    services:
      arch-app:
        build:
          context: .
        platform: linux/amd64
        image: ghcr.io/20241204/docker-arch-test:latest
        command:
          - "/bin/ash"
          - "/app/arch-test.sh"

## docker-compose-arm64.yml 内容
    services:
      arch-app:
        build:
          context: .
        platform: linux/arm64/v8
        image: ghcr.io/20241204/docker-arch-test:latest
        command:
          - "/bin/ash"
          - "/app/arch-test.sh"
          
## Dockerfile 内容
    FROM alpine:latest
    ADD arch-test.sh /app/
    WORKDIR /app
    CMD ["/bin/ash", "arch-test.sh"]
    
# 构建并推送多平台的镜像
    docker buildx build --platform linux/amd64,linux/arm64/v8 -t ghcr.io/20241204/docker-arch-test:latest --push .

## arm64 平台架构打印测试
    docker run --rm --platform linux/arm64 ghcr.io/20241204/docker-arch-test:latest
    # 打印效果
        aarch64
        Linux

## amd64 平台架构打印测试
    docker run --rm --platform linux/amd64 ghcr.io/20241204/docker-arch-test:latest
    # 打印效果
        x86_64
        Linux

## 测试成功，此方案可行有效
