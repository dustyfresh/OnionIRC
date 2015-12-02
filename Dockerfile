FROM debian:jessie
MAINTAINER dustyfresh, https://github.com/dustyfresh

RUN apt-get update && apt-get -y install ngircd vim tor build-essential libssl-dev python-setuptools python-pip supervisor
ADD ./ssl/server.crt /etc/ngircd/server.crt
ADD ./ssl/server.key /etc/ngircd/server.key
ADD ./conf/supervise-ngircd.conf /etc/supervisor/conf.d/supervise-ngircd.conf
ADD ./conf/supervise-tor.conf /etc/supervisor/conf.d/supervise-tor.conf
ADD ./conf/rsyslog.conf /etc/rsyslog.conf
ADD ./conf/ngircd.motd /etc/ngircd/ngircd.motd
ADD ./conf/ngircd.conf /etc/ngircd/ngircd.conf
ADD ./conf/torrc /etc/tor/torrc
CMD ["/usr/bin/supervisord", "-n"]
