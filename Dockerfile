FROM ubuntu:bionic
MAINTAINER David Ortiz <z.david.ortiz@gmail.com>

ARG USER_NAME=formulita
ARG USER_HOME="/home/${USER_NAME}"

# Install dependencies and set user
RUN apt-get update -y -q \
 && apt-get dist-upgrade -y -q \
 && apt-get install -y -q apt-utils git vim wget bzip2 build-essential \
    libssl-dev libreadline-dev zlib1g-dev \
 && apt-get -y -q autoremove --purge \
 && apt-get -y -q clean \
 && adduser --disabled-password --home ${USER_HOME} --gecos "" \
    --shell /bin/bash ${USER_NAME} \
 && passwd -d ${USER_NAME} \
 && chown -R ${USER_NAME}: ${USER_HOME}

USER ${USER_NAME}

# Install rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
 && git clone https://github.com/rbenv/ruby-build.git \
    ~/.rbenv/plugins/ruby-build

# Install ruby using rbenv
ENV PATH="${USER_HOME}/.rbenv/shims:${USER_HOME}/.rbenv/bin:${PATH}"
ARG APP_HOME=${USER_HOME}/app
WORKDIR ${APP_HOME}
COPY .ruby-version .ruby-gemset ${APP_HOME}/
RUN rbenv install

# Install gem dependencies
USER ${USER_NAME}
COPY Gemfile.lock Gemfile formulita_backend.gemspec ${APP_HOME}/
COPY lib/formulita_backend/version.rb ${APP_HOME}/lib/formulita_backend/
RUN gem install bundler
RUN bundle install

COPY . ${APP_HOME}

USER root
RUN chown -R ${USER_NAME}: ${APP_HOME}

USER ${USER_NAME}
