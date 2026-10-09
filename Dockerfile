FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    make \
    gcc \
    jq \
    diffutils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN make check

RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
