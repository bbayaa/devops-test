FROM ubuntu:18.04
LABEL maintainer="Belal Bayaa <belal.db@gmail.com>"

RUN apt-get update -y \
    && apt-get install ruby ruby-dev ruby-bundler build-essential git curl -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && git clone https://github.com/bbayaa/devops-test.git /opt/devops-test \
    && gem install puma foreman \
    && gem install bundler -v $(grep -A 1 "BUNDLED WITH" /opt/devops-test/Gemfile.lock | tail -n 1) \
    && (cd /opt/devops-test && bundle install)

WORKDIR /opt/devops-test

ENTRYPOINT ["bundle", "exec"]