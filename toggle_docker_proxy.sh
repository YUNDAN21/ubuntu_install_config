#!/bin/bash

# 检查是否设置了代理
PROXY_CONF="/etc/systemd/system/docker.service.d/http-proxy.conf"

if [ -f "$PROXY_CONF" ]; then
    # 如果存在代理配置文件，则关闭代理
    echo "正在关闭Docker代理..."
    rm -f "$PROXY_CONF"
    systemctl daemon-reload
    systemctl restart docker
    echo "Docker代理已关闭。"
else
    # 如果不存在代理配置文件，则开启代理
    echo "正在开启Docker代理..."
    mkdir -p /etc/systemd/system/docker.service.d/
    cat <<EOF | sudo tee "$PROXY_CONF" > /dev/null
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:7890" 
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
EOF
    systemctl daemon-reload
    systemctl restart docker
    echo "Docker代理已开启。"
fi
