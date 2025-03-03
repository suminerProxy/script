#!/bin/bash

# 配置区域
# 1. SSH 配置
ALLOW_ROOT_LOGIN=true  # 是否允许 root 用户通过 SSH 登录，设置为 true 或 false

# 2. 公钥配置
PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuc0k4Y3KGL4axdu3dWDnfplR3KzME8+QFcRUJQDtnUIwfL/4Yv+PUzzSX+x1iogZwO6QgTXXabZ9RtcB4Ua0ehSVV/wIaI6k8vLRt61jQ2WKK6HkmbYieHO2xU/spnblVa7aS0M40ukg664JIKxKLQ8rkYT4sZ+zvw2L9rOhYy0cU+MyxDXQaEkyG3bfyceQ2la5WV/W1brE03vPsrLf69n4feIZjJrOo78f60OlC8Za6hHoBOf8voQdYX+hEO0/rGSTrprSlFmkoddrNxtl+r0gLCzafbh+rjsHhyFBJqyW4HgiYG9a6yBr/R8yM3DtMhnT2euZKpMbtGSw9SorHVhdW94dVKChPwW1pYwRlVgvdXvHubw8uOT3C5xyNL1c2e0qifD9DTRMGwrCI6JbIbNp8TlofrhXREVdrs6TVlx5L0gMIT6UMSvfvSjTr4nXJxXW/OBTcORKpbzS9DGZxQ6VucrzT6gcDFOMfyM+OghDlUt8KHtkzdZx3iZEBAvC0sochdKsV11b7v44NKXO4Fj6fQOF/rlLFoGThNQaEJ4cES4IgJr8w43/PeaifbjD0ohs8pZyzmMgm7xVs3V74904V04IFybhIclTZRRPgR4i7CzF82VBmtEyhLAFEMwSP4I83cHwziVPMdtVmQNiLCgPLgFj+K0ENqW4tCmqO0Q== bab-mac@baby.com"

# 检查是否以 root 用户运行脚本
if [ "$(id -u)" -ne 0 ]; then
  echo "请使用 root 用户运行此脚本。"
  exit 1
fi

# 1. 根据配置修改 SSH 配置，允许 root 用户直接登录
if [ "$ALLOW_ROOT_LOGIN" == "true" ]; then
  echo "修改 SSH 配置，允许 root 用户直接登录..."
  echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
  systemctl restart ssh
else
  echo "不允许 root 用户通过 SSH 直接登录。"
fi

# 2. 添加公钥到 root 用户的 authorized_keys
echo "添加公钥到 root 用户的 authorized_keys..."
mkdir -p /root/.ssh
echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

echo "脚本执行完成！"