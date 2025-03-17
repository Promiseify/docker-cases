FROM nginx:alpine

RUN addgroup -S user && adduser -S -G user xiaohe
USER xiaohe

COPY nginx.conf /etc/nginx/nginx.conf
COPY html/ /usr/share/nginx/html/

# HEALTHCHECK --interval=30s --timeout=3s \
# CMD curl -f http://localhost/health || exit 1

EXPOSE 80