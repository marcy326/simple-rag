# ベースイメージ
FROM python:3.10-slim

# 必要なライブラリのインストール
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Streamlitアプリのソースコードをコピー
COPY app.py /app/app.py

# 作業ディレクトリを設定
WORKDIR /app

# Streamlitの起動
ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.enableXsrfProtection=true"]
