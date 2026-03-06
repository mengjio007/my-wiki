# My Wiki

类似 [OI Wiki](https://oi-wiki.org/) 的个人知识库，使用 MkDocs Material 构建。

## 本地开发

```bash
# 安装依赖
pip install -r requirements.txt

# 本地预览
mkdocs serve
```

访问 http://127.0.0.1:8000 查看效果。

## 部署到 GitHub Pages

### 前置条件

1. 在 GitHub 创建仓库（如 `my-wiki`）
2. 本地已配置 git 并关联远程仓库

### 部署步骤

```bash
# 安装依赖
pip install -r requirements.txt

# 部署到 GitHub Pages（会推送到 gh-pages 分支）
mkdocs gh-deploy
```

### 配置 GitHub Pages

1. 打开仓库 **Settings** → **Pages**
2. **Source** 选择 **Deploy from a branch**
3. **Branch** 选择 `gh-pages`，目录选 `/ (root)`
4. 保存后等待几分钟，站点将发布到 https://mengjio007.github.io/my-wiki/
