## build : docker build -t lightedge-upfservice-manager .
## run :   docker run --net=host --rm --privileged -it lightedge-upfservice-manager

FROM ubuntu:19.10
MAINTAINER Roberto Riggio <rriggio@fbk.eu>

# Installing python dependencies
RUN sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list


RUN apt update
RUN apt -y install python3-pip wget unzip iptables
RUN pip3 install tornado==6.0.3 pymodm==0.4.1 influxdb==5.2.3 python-iptables==0.14.0
#RUN pip3 install empower-core==1.0.5 

# Fetching the latest repository from lightedge-upfservice-manager.
RUN wget https://github.com/lightedge/lightedge-upfservice-manager/archive/master.zip
RUN unzip master.zip
RUN rm master.zip
RUN mkdir -p /etc/lightedge/
RUN ln -sf /lightedge-upfservice-manager-master/conf/ /etc/lightedge/upfservice
RUN mkdir -p /var/www/lightedge/
RUN ln -sf /lightedge-upfservice-manager-master/webui/ /var/www/lightedge/upfservice

#ADD conf/runtime.cfg /etc/empower/
#ADD conf/logging.cfg /etc/empower/

# Run the controller
ENTRYPOINT ["python3.7", "/lightedge-upfservice-manager-master/lightedge-upfservice-manager.py"]
#ENTRYPOINT ["./lightedge-upfservice-manager-master/lightedge-upfservice-manager.py"]

# Expose Web GUI
EXPOSE 8888

# Expose influxdb
EXPOSE 8086
