#######EXPORTER#############
FROM qa.int.stratio.com/stratio/stratio-base:2.0.0 AS exporter-build
ARG EXPORTER_VERSION=0.1.1

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    make \
    gcc \
    wget \
    git

RUN cd /tmp \
    && wget https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz \
    && tar xvf go1.14.1.linux-amd64.tar.gz \
    && mv go /usr/local

ENV GOROOT=/usr/local/go
ENV GOPATH=$HOME/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

RUN mkdir -p $GOPATH/src/github.com/cespare/ \
    && cd $GOPATH/src/github.com/cespare/ \
    && git clone https://github.com/cespare/xxhash.git \
    && cd xxhash \
    && git checkout tags/v2.0.0 \
    && mkdir v2 \
    && mv * v2 2> /dev/null || true

RUN cd $GOPATH/src \
    && mkdir -p github.com/brandond/ \
    && cd github.com/brandond \
    && git clone https://github.com/brandond/syslog_ng_exporter.git \
    && cd syslog_ng_exporter \
    && git checkout tags/${EXPORTER_VERSION} \
    && make
#######################
FROM balabit/syslog-ng:3.26.1

WORKDIR /syslog-ng

COPY --from=exporter-build /go/src/github.com/brandond/syslog_ng_exporter/syslog_ng_exporter /bin/syslog_ng_exporter

#ADD entrypoint.sh /entrypoint.sh
#ADD run.sh /run.sh
#ADD exporter.sh /exporter.sh

RUN chmod +x /bin/syslog_ng_exporter \
    && chmod +x /usr/sbin/syslog-ng

EXPOSE 514/udp
EXPOSE 601/tcp
EXPOSE 6514/tcp
EXPOSE 9577
