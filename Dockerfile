# Dockerfile.rails
FROM ruby:alpine3.13 AS rails-app

ARG USER_ID
ARG GROUP_ID

RUN adduser --disabled-password --gecos '' --uid $USER_ID user

ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

RUN apk add --no-cache build-base nodejs yarn sqlite-dev postgresql-dev

ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY trainer_panel/ .
RUN rm -rf node_modules vendor

RUN gem install rails bundler pg
RUN bundle install
RUN yarn install
RUN rails webpacker:install

RUN chown -R user:user $INSTALL_PATH
WORKDIR $INSTALL_PATH

USER $USER_ID
EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]