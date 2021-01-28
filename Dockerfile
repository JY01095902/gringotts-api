FROM alpine:latest

# 配置镜像源并下载时区包，go.1.15后已经不用了
# RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
#     && apk add --no-cache tzdata
# ENV TZ Asia/Shanghai

RUN mkdir /app

WORKDIR /app
COPY gringotts-api ./gringotts-api

EXPOSE 9297

CMD [ "./gringotts-api" ]