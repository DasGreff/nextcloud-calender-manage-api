FROM python:3.14-slim-trixie

WORKDIR /app

COPY src/ ./src/
COPY requirements.txt ./

RUN apt update && \
    apt install -y --no-install-recommends gcc libc6-dev libxml2-dev libxslt1-dev zlib1g-dev && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

CMD ["python", "src/app.py"]
