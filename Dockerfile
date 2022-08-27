FROM ubuntu:16.04

ENV TZ=GMT
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update && \
    apt-get -qy dist-upgrade && \
    apt-get -qy install libterm-readline-perl-perl dialog && \
    apt-get -qy install sudo apt-utils software-properties-common xauth dialog

COPY deb/* /tmp/

# firefox-esr needs these. the list can probably be trimmed
RUN apt-get install -y libasound2 libatk1.0-0 libcairo-gobject2 libcairo2 libfontconfig1 libfreetype6 libgdk-pixbuf2.0-0 libgtk-3-0 libgtk2.0-0 libpango-1.0-0 \
    libstartup-notification0 libxt6 && \
    dpkg -i /tmp/*.deb; apt-get -fqy install

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

# Optional: Disable modern TLS because iLO is very old.  See
# http://framer99.blogspot.com/2015/02/investigatingfixing-hp-ilo2-java-remote.html
RUN echo "jdk.tls.disabledAlgorithms=TLSv1.1, TLSv1.2" >> /etc/java-8-openjdk/security/java.security

USER ffuser
RUN mkdir -p /home/ffuser/.java/deployment/security && \
    touch /home/ffuser/.java/deployment/security/exception.sites && \
    touch /home/ffuser/.java/hp.properties

COPY entrypoint.sh /home/ffuser

ENTRYPOINT [ "/home/ffuser/entrypoint.sh" ]
