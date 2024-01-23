FROM ruby:3.2.0

RUN apt-get update -yqq

RUN apt-get install -yqq --no-install-recommends \
  nodejs \
  postgresql-client \
  && apt-get -q clean

COPY . /usr/src/app/

WORKDIR /usr/src/app/

RUN bundle
