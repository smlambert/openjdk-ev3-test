#!/bin/bash
set -e

cd /home/compiler/
wget https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk-10-ev3/lastSuccessfulBuild/artifact/build/jdk-ev3.tar.gz
tar -xf jdk-ev3.tar.gz
pwd
ls
sudo update-alternatives --install /usr/bin/java java /home/compiler/jdk/bin/java 2000
java -version
exit 0

apt-get update
apt-get install --yes --no-install-recommends apt-utils
apt-get install --yes --no-install-recommends build-essential
apt-get install --yes --no-install-recommends git
apt-get install --yes --no-install-recommends ant
git clone https://github.com/AdoptOpenJDK/openjdk-tests.git
cd openjdk-tests
cpan install JSON Text::CSV
export BUILD_LIST=openjdk_regression
export JAVA_BIN=/home/compiler/jdk/bin/
export SPEC=linux_arm
export JAVA_VERSION=SE100
cd TestConfig
./get.sh   -t /home/compiler/openjdk-tests   -p   linux_arm   -v    openjdk10
make -f run_configure.mk
make compile
make sanity
