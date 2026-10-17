FROM node:alpine3.22

WORKDIR /tmp

COPY index.js index.html package.json ./

# 在复制代码后、安装依赖前，加入以下这段代码：
# 1. 自动下载当前最新的 cloudflared 二进制文件
# 2. 给它赋予执行权限
# 3. 顺便清理缓存以减小镜像体积
RUN curl -fsSL "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" \
      -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared && \
    # 如果以后需要部署到 arm64 架构（比如某些ARM云服务器），可以使用下面这行（去掉注释，删掉上面amd64那行）：
    # curl -fsSL "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" -o /usr/local/bin/cloudflared && chmod +x /usr/local/bin/cloudflared && \
    rm -rf /var/cache/apk/*

EXPOSE 3000/tcp

RUN apk update && apk upgrade &&\
    apk add --no-cache openssl curl gcompat iproute2 coreutils &&\
    apk add --no-cache bash && \
    chmod +x index.js && \
    npm install

CMD ["node", "index.js"]
