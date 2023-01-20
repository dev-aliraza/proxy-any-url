FROM nginx:1.23.3-alpine-slim

WORKDIR /

RUN apk add --no-cache jq=1.6-r2

COPY proxy-any-url.sh /proxy-any-url.sh

ENTRYPOINT ["./proxy-any-url.sh"]