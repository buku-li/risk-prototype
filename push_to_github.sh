#!/usr/bin/env bash
# 推送原型到 GitHub（HTTPS + Token 认证）
#
# 用法（推荐：token 只存在于当前命令，不落盘）：
#   GH_USER=你的用户名 GH_REPO=仓库名 GH_TOKEN=github_pat_xxx bash push_to_github.sh
#
# 前置：在 GitHub 网页创建一个「空的」私有/公开仓库（不要勾选 Add README / .gitignore / License）
set -euo pipefail

: "${GH_USER:?缺少环境变量 GH_USER（GitHub 用户名）}"
: "${GH_REPO:?缺少环境变量 GH_REPO（仓库名）}"
: "${GH_TOKEN:?缺少环境变量 GH_TOKEN（Personal Access Token）}"

cd "$(dirname "$0")"

# 若已存在 origin 先移除，避免重复添加报错
git remote remove origin 2>/dev/null || true
git remote add origin "https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git"

echo ">> 推送 main 分支到 https://github.com/${GH_USER}/${GH_REPO}"
git push -u origin main

# 推送成功后把 token 从 remote URL 中抹掉，避免明文留在 .git/config
git remote set-url origin "https://github.com/${GH_USER}/${GH_REPO}.git"
echo ">> 完成：已推送，并从 remote URL 中清除 token"
echo ">> 下一步：仓库 Settings → Pages → Build and deployment → Source 选 Deploy from a branch → Branch: main / 目录: /(root) → Save"
