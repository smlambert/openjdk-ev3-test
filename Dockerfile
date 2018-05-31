FROM ev3dev/ev3dev-stretch-ev3-generic

# copy qemu & scripts to the container
COPY java-wrapper mktest.sh /opt/jdktest/

# Use this when there is a need for input during docker image building process
ENV DEBIAN_FRONTEND noninteractive

# Install required OS and testing tools
RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
      apt-utils build-essential git ant ant-contrib libtext-csv-perl libjson-perl sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN adduser --disabled-password --gecos '' docker && \
    adduser docker sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker

CMD [ "/bin/bash", "/opt/jdktest/mktest.sh" ]
