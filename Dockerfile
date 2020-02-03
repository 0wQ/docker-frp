FROM alpine:3.10

LABEL maintainer="Mizore <me@mizore.cn>"

ENV FRP_VERSION=0.31.1

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache --virtual .build-deps curl \
    \
    && mkdir /tmp/frp \
    && curl -fsSL https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz | tar -xzC /tmp/frp --strip-components=1 \
    \
    && install -Dm755 /tmp/frp/frpc /usr/bin/frpc \
    && install -Dm644 /tmp/frp/frpc.ini /etc/frp/frpc.ini \
    # && install -Dm644 /tmp/frp/systemd/frpc.service /usr/lib/systemd/user/frpc.service \
    \
    && install -Dm755 /tmp/frp/frps /usr/bin/frps \
    && install -Dm644 /tmp/frp/frps.ini /etc/frp/frps.ini \
    # && install -Dm644 /tmp/frp/systemd/frps.service /usr/lib/systemd/user/frps.service \
    \
    && rm -rf /tmp/frp \
    \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

CMD ["frps", "-c", "/etc/frp/frps.ini"]
