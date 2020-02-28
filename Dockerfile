FROM ruby:2.4

RUN apt-get update -qq && apt-get install -y build-essential \
  libpq-dev \
  postgresql-client \
# for Solr
  ca-certificates-java \
  libxrandr2 \
  libxinerama1 \
  libgl1-mesa-glx \
  libgl1 \
  libgtk2.0-0 \
  libatk-wrapper-java-jni \
  libgif7 \
  libpulse0 \
# openjdk-8-jre \
# for nokogiri
  libxml2-dev \
  libxslt1-dev \
  # for cron scheduler job
  cron \
  vim

RUN wget http://security.debian.org/debian-security/pool/updates/main/o/openjdk-8/openjdk-8-jre-headless_8u242-b08-1~deb9u1_amd64.deb \
&& wget http://security.debian.org/debian-security/pool/updates/main/o/openjdk-8/openjdk-8-jre_8u242-b08-1~deb9u1_amd64.deb \
&& wget http://security.debian.org/debian-security/pool/updates/main/o/openjdk-8/openjdk-8-jdk-headless_8u242-b08-1~deb9u1_amd64.deb \
&& wget http://security.debian.org/debian-security/pool/updates/main/o/openjdk-8/openjdk-8-jdk_8u242-b08-1~deb9u1_amd64.deb
RUN dpkg -i   openjdk-8-jre-headless_8u242-b08-1~deb9u1_amd64.deb openjdk-8-jre_8u242-b08-1~deb9u1_amd64.deb   openjdk-8-jdk-headless_8u242-b08-1~deb9u1_amd64.deb openjdk-8-jdk_8u242-b08-1~deb9u1_amd64.deb && update-alternatives --set java  /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

RUN gem install bundler --version 2.1.4 --force
ENV APP_HOME /docker_build
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME/

COPY config/docker/database.yml config/

COPY ./config/docker/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
RUN chmod u+x $APP_HOME/bin/*
ENTRYPOINT ["/docker-entrypoint.sh"]
