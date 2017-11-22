FROM ruby:2.2.5-alpine

ADD Gemfile /taskwarrior-web/Gemfile
ADD taskwarrior-web.gemspec /taskwarrior-web/taskwarrior-web.gemspec
ADD lib/taskwarrior-web/version.rb /taskwarrior-web/lib/taskwarrior-web/version.rb

# Gemfile expects to run `git ls-files` (bad dependency, if deployment is not coming from git). When this is removed, just drop the 'apk add git' dependency.
RUN apk --update add --virtual task-dependencies build-base ruby-dev gnutls-dev util-linux-dev ca-certificates wget cmake \
    && apk add libstdc++ gnutls libuuid tzdata \
    && apk add git \
    && wget https://taskwarrior.org/download/task-2.5.1.tar.gz \
    && tar xzf task-2.5.1.tar.gz \
    && cd task-2.5.1 \
    && cmake -DCMAKE_BUILD_TYPE=release . \
    && make \
    && cp src/task /usr/bin/task \
    && cd .. \
    && rm -rf task-2.5.1 task-2.5.1.tar.gz \
    && cd /taskwarrior-web \
    && bundle install \
    && addgroup -S taskwarrior-web && adduser -D -S -g "" -h /taskdata -G taskwarrior-web taskwarrior-web \
    && rm -rf /root/.gem /root/.bundle \
    && apk del task-dependencies

ADD . /taskwarrior-web

USER taskwarrior-web

EXPOSE 3000

VOLUME /taskdata

ENV TASKRC "/taskdata/.taskrc"
ENV TASKDATA "/taskdata"

CMD ["/usr/bin/env", "rackup", "-p", "3000", "-o", "0.0.0.0", "/taskwarrior-web/config.ru"]
