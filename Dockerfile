# docker build -t keystone-mitaka .
FROM centos:7
MAINTAINER Mario David <mariojmdavid@gmail.com>

RUN yum -y update && \
    yum -y install epel-release centos-release-openstack-mitaka

RUN yum -y update && \
    yum -y install bind-utils chrony git httpd \
                   mod_ssl mod_wsgi openstack-dashboard \
                   openstack-keystone wget

RUN yum -y install https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.1.0/cjose-0.4.1-1.el7.centos.x86_64.rpm
RUN yum -y install https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.1.2/mod_auth_openidc-2.1.2-1.el7.centos.x86_64.rpm

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*

VOLUME [ "/sys/fs/cgroup" ]
EXPOSE 80 5000 35357
CMD ["/usr/sbin/init"]

