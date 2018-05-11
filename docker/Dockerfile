FROM alpine

RUN apk add --no-cache task ruby python \
 && apk add --no-cache --virtual .build-dependencies \
            ruby-dev \
            make \
            g++

COPY docker/.taskrc /root/.taskrc
COPY lib /opt/app/lib
COPY bin /opt/app/bin
COPY taskwarrior-web.gemspec LICENSE README.md /opt/app/

WORKDIR /opt/app

RUN GEM=$(gem build taskwarrior-web.gemspec | awk '/File: .*/{ print $2 }') \
 && gem install ${GEM} --no-document

RUN apk del --no-cache .build-dependencies

EXPOSE 5678

VOLUME /root/

CMD task-web -F -L