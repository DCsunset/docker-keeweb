# This docker image only provides http connection in contrast to the official docker image.
# This image is more suitable to be used behind a reverse-proxy.

FROM alpine:latest AS builder
RUN apk add --no-cache curl tar
RUN curl -Ss -L -O https://github.com/keeweb/keeweb/archive/gh-pages.tar.gz \
	&& tar -xvf gh-pages.tar.gz -C /
# Install plugins
RUN curl -Ss -L -O https://github.com/keeweb/keeweb-plugins/archive/master.tar.gz \
	&& tar -xvf master.tar.gz -C / \
	&& mv /keeweb-plugins-master/docs /keeweb/plugins


FROM nginx:alpine
LABEL MAINTAINER="DCsunset"

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /keeweb-gh-pages /app/keeweb

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80
