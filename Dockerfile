#Uncomment the following line for regular x86 systems
FROM debian:jessie
#Uncomment the following line for the raspberry pi
#FROM resin/rpi-raspbian:jessie
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
RUN chown -R irc:irc /etc/ngircd
CMD ["/usr/bin/supervisord", "-n"]
