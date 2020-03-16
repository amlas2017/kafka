#!/bin/bash

echo "hosts file setup..."

sudo echo "192.102.10.101 poste1" | sudo tee -a /etc/hosts
sudo echo "192.102.10.102 poste2" | sudo tee -a /etc/hosts
sudo echo "192.102.10.103 poste3" | sudo tee -a /etc/hosts


echo "installing JDK and Kafka..."

su -c "yum -y install java-1.8.0-openjdk-devel"

#disabling iptables
/etc/init.d/iptables stop

su -c "yum -y install wget nc vim"

echo "disable firewall..............."
sudo setenforce 0
sudo sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

echo "Installing Apache Zookeeper............"
sudo  wget http://miroir.univ-lorraine.fr/apache/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz && sudo tar -xvf zookeeper-3.4.14.tar.gz && \
   sudo mv zookeeper-3.4.14 ./zookeeper  &&  \
   sudo chown -R vagrant:vagrant zookeeper    &&   \
   sudo mv zookeeper /opt
   sudo mv /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg

echo "Installing Apache kafka........"
sudo wget  http://mirror.ibcp.fr/pub/apache/kafka/2.4.0/kafka_2.11-2.4.0.tgz  && sudo tar -xvf kafka_2.11-2.4.0.tgz &&  \
   sudo mv kafka_2.11-2.4.0 ./kafka
   sudo chown -R vagrant:vagrant kafka
   sudo mv kafka /opt
echo 'export PATH=$PATH:/opt/zookeeper' >> ~/.bashrc
echo 'export PATH=$PATH:/opt/kafka' >> ~/.bashrc

sudo cat /opt/zookeeper/conf/zoo.cfg << EOF
  server.1=poste1:2888:3888
  server.2=poste2:2888:3888  # à modifier
  server.3=poste3:2888:3888
  EOF

sudo mkdir -p /var/zookeeper/data 
cd /var/  && sudo chown -R vagrant:vagrant /zookeeper
sudo touch /zookeeper/myid
 
