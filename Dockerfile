FROM ruby:2.7.1-slim

ENV LC_ALL=C.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN apt-get update && apt-get install curl wget gnupg2 -y && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install build-essential \
    bc libcurl4-openssl-dev libsqlite3-dev iproute2 sqlite3 -y && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get install -y nodejs

RUN gem install bundler

RUN mkdir /app
WORKDIR /app

ENTRYPOINT ["./docker-entrypoint.sh"]
