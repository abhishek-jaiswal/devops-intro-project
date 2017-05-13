#!/bin/bash -eux


sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:webupd8team/java -y

echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections


# JDK and JRE are required for Jenkins
#apt-get install -y openjdk-7-jre openjdk-7-jdk unzip dos2unix
apt-get install -y openjdk-8-jre openjdk-8-jdk unzip dos2unix

wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list

apt-get update
apt-get install -y jenkins
#apt-get upgrade -y

# copy premade configuration files
# jenkins default config, to set --prefix=jenkins
cp -f /tmp/jenkins/jenkins /etc/default
# fix dos newlines for Windows users
dos2unix /etc/default/jenkins
# install some extra plugins
/bin/bash /tmp/jenkins/install_jenkins_plugins.sh
# jenkins security and pipeline plugin config
cp -f /tmp/jenkins/config.xml /var/lib/jenkins
# set up username for vagrant
mkdir -p /var/lib/jenkins/users/vagrant
cp /tmp/jenkins/users/vagrant/config.xml /var/lib/jenkins/users/vagrant
# example job
mkdir -p /var/lib/jenkins/jobs
cd /var/lib/jenkins/jobs
tar zxvf /tmp/jenkins/example-job.tar.gz

# set permissions or else jenkins can't run jobs
chown -R jenkins:jenkins /var/lib/jenkins

# restart for jenkins to pick up the new configs
service jenkins restart