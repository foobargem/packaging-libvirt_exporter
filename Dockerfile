FROM golang:1.14.2-alpine3.11 as builder

ARG LIBVIRT_REPO=https://github.com/zhangjianweibj/prometheus-libvirt-exporter.git
ARG LIBVIRT_BRANCH=master

ENV GOPATH=/go

RUN apk add --no-cache git

RUN mkdir -p $GOPATH/src/github.com/zhangjianweibj/prometheus-libvirt-exporter && \
  cd $GOPATH/src/github.com/zhangjianweibj/prometheus-libvirt-exporter && \
  git init && \
  git remote add origin $LIBVIRT_REPO && \
  git fetch origin $LIBVIRT_BRANCH && \
  git reset --hard FETCH_HEAD && \
  GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o libvirt_exporter prometheus-libvirt-exporter.go


FROM centos:7.4.1708

RUN yum -y install rpm-build git tar gzip
RUN mkdir -p /root/libvirt_exporter-2020.1 \
	     /root/src /root/rpmbuild/{SOURCES,SPECS}

WORKDIR /root/libvirt_exporter-2020.1
copy --from=builder /go/src/github.com/zhangjianweibj/prometheus-libvirt-exporter/libvirt_exporter .

WORKDIR /root/src
RUN git clone -b v2020.1 https://github.com/foobargem/packaging-libvirt_exporter.git

WORKDIR /root/src/packaging-libvirt_exporter
RUN cp -arp package/rpm/libvirt-exporter.service package/rpm/sysconfig/ \
	/root/libvirt_exporter-2020.1/
RUN cp package/rpm/libvirt_exporter.spec /root/rpmbuild/SPECS/

WORKDIR /root
RUN tar cvzf /root/rpmbuild/SOURCES/libvirt_exporter-2020.1.tar.gz libvirt_exporter-2020.1/

WORKDIR /root/rpmbuild
RUN rpmbuild -ba SPECS/libvirt_exporter.spec
