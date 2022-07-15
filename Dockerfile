FROM ruby:3-alpine

RUN apk add -U postgresql-dev build-base git gcompat \
  && adduser -S ruby -u 1000 -D

USER ruby
