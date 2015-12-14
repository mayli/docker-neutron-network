FROM ubuntu:latest
MAINTAINER Mengyang Li <mayli.he@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-get update && \
	apt-get install -y \
		python build-essential python-dev python-lxml \
		libxml2-dev libxslt1-dev python-dev python-setuptools git && \
	easy_install pip

RUN git clone https://github.com/openstack/neutron.git && \
	git clone https://github.com/openstack/networking-brocade.git && \
	git clone https://github.com/openstack/networking-cisco.git

RUN cd neutron && git checkout stable/kilo && \
	pip install -r requirements.txt && python setup.py install
RUN cd networking-brocade && git checkout master && \
	pip install -r requirements.txt && python setup.py install
RUN cd networking-cisco && git checkout stable/kilo && \
	pip install -r requirements.txt && python setup.py install

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD test.py /root/test.py

WORKDIR /root
ENTRYPOINT ["python", "test.py"]
