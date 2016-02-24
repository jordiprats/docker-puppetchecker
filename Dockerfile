FROM ubuntu:14.04
MAINTAINER Jordi Prats

ENV EYP_MODULEPATH /module

COPY runme.sh /usr/local/bin/

#
# timezone and locale
#
RUN echo "Europe/Andorra" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

RUN export LANGUAGE=en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	export LC_ALL=en_US.UTF-8 && \
	locale-gen en_US.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

RUN DEBIAN_FRONTEND=noninteractive apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install gcc -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install make -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install wget -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install strace -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install libxml2-dev -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install zlib1g-dev -y

# inception
RUN DEBIAN_FRONTEND=noninteractive apt-get install docker.io -y

#
# puppet repo
#
RUN wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb >/dev/null 2>&1
RUN dpkg -i puppetlabs-release-wheezy.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get update

#
# puppet packages
#
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y puppet puppet-common puppet-el puppet-testsuite vim-puppet

#templates puppe module generate
RUN git clone https://github.com/AtlasIT-AM/puppet-module-skeleton.git /usr/local/src/puppet-module-skeleton
RUN bash -c 'cd /usr/local/src/puppet-module-skeleton; bash install.sh'

#install Gems
RUN bash -c 'cd /root; puppet module generate eyp-lol --skip-interview'
RUN bash -c 'cd /root/eyp-lol; bundle install'
#cleanup
RUN rm -fr /root/eyp-lol

CMD /bin/bash /usr/local/bin/runme.sh
