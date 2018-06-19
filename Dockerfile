FROM ubuntu:14.04

# Update system
RUN apt-get update && \
  apt-get install -y wget curl dnsutils python-pip python-dev python-apt software-properties-common dmidecode

# Setup salt ppa
RUN echo deb http://repo.saltstack.com/apt/ubuntu/14.04/amd64/2018.3 trusty main | tee /etc/apt/sources.list.d/saltstack.list && \
	wget -O - https://repo.saltstack.com/apt/ubuntu/14.04/amd64/2018.3/SALTSTACK-GPG-KEY.pub | sudo apt-key add -

# Install salt master/minion/api
RUN apt-get update && \
	apt-get install -y salt-master salt-minion

# Setup halite
RUN pip install cherrypy docker-py halite

# Add salt config files
ADD etc/master /etc/salt/master
ADD etc/minion /etc/salt/minion

# Expose volumes
VOLUME ["/etc/salt", "/var/cache/salt", "/var/logs/salt", "/srv/salt", "/srv/pillar"]

# Exposing salt master and api ports
EXPOSE 4505 4506 8080 8081

# Add and set start script
ADD start.sh /start.sh
CMD ["bash", "start.sh"]
