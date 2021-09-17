FROM ubuntu:16.04

ENV TZ=GMT
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update && \
    apt-get -qy dist-upgrade && \
    apt-get -qy install libterm-readline-perl-perl dialog && \
    apt-get -qy install sudo apt-utils software-properties-common xauth dialog

COPY deb/* /tmp/

RUN dpkg -i /tmp/*.deb; apt-get -fqy install

RUN useradd -m -s /bin/bash -c "Firefox user" ffuser && \
    mkdir -p /etc/sudoers.d && \
    echo "ffuser ALL=(ALL) NOPASSWD: /bin/cat" > /etc/sudoers.d/ffuser && \
    chmod 0440 /etc/sudoers.d/ffuser

RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
    debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | \
    debconf-set-selections && \
    echo "deb http://archive.canonical.com/ubuntu xenial partner" | tee -a /etc/apt/sources.list && \
    apt-get -q update && \
    apt-get -qy install adobe-flashplugin icedtea-8-plugin
    
RUN echo "jdk.tls.disabledAlgorithms=TLSv1.1, TLSv1.2" >> /etc/java-8-openjdk/security/java.security

USER ffuser
RUN mkdir -p /home/ffuser/.java/deployment/security && \
    touch /home/ffuser/.java/deployment/security/exception.sites && \
    touch /home/ffuser/.java/hp.properties

COPY entrypoint.sh /home/ffuser

ENTRYPOINT [ "/home/ffuser/entrypoint.sh" ]
