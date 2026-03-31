# 使用 Python 3.10 基础镜像
FROM python:3.10-slim

# 安装 Camoufox/Firefox 运行必备的系统库
RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    libxt6 \
    libx11-xcb1 \
    libasound2 \
    libglib2.0-0 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 复制项目文件
COPY . .

# 安装 Python 包
RUN pip install --no-cache-dir -r requirements.txt

# 重要：提前下载 Camoufox 浏览器二进制文件
# 这样可以避免在 HF Space 启动时因下载大文件导致超时
RUN python -m camoufox fetch

# 暴露 HF 默认端口
EXPOSE 7860

# 启动命令：强制指定浏览器类型为 camoufox
CMD ["python", "api_solver.py", "--host", "0.0.0.0", "--port", "7860", "--browser_type", "camoufox", "--thread", "2", "--debug"]
