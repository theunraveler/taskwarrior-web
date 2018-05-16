FROM alpine

RUN apk add --no-cache task ruby python \
 && apk add --no-cache --virtual .build-dependencies ruby-dev make g++ \
 && gem install taskwarrior-web --no-document \
 && apk del --no-cache .build-dependencies

RUN echo '*/30    *       *       *       *       /opt/app/restart.sh' > /etc/crontabs/root

COPY app /opt/app

EXPOSE 80

CMD crond -l2 -L /var/log/crond.log && /opt/app/start.sh
