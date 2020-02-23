# Use python version 3.7.6 for latest stretch / stretch for openjdk support (alpine issues)
FROM python:3.7.6-slim-stretch

ARG DOCKER_VERSION=19.03.5
ARG GOSS_VERSION=v0.3.9

# Create directories
RUN mkdir -p /var/run/sshd \
 && mkdir -p /usr/share/man/man1

# Install requirements
RUN apt update -y \
 && apt install -y openssh-server openjdk-8-jdk-headless git curl \
# Setup docker CLI only
 && curl -sfL -o docker.tgz "https://download.docker.com/linux/static/stable/armhf/docker-${DOCKER_VERSION}.tgz" \
 && tar -xzf docker.tgz docker/docker --strip=1 --directory /usr/local/bin \
 && mv docker /usr/local/bin \
 && rm docker.tgz

# Add docker-compose
RUN apt install -y libssl-dev python-dev libffi-dev gcc libc-dev make \
&& pip install docker-compose

# Add node & dockerlint
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash - \
 && apt install -y nodejs \
 && npm install -g dockerlint

# Add goss / dgoss for docker / dcgoss for docker compose
# See https://github.com/aelsabbahy/goss/releases for release versions
RUN curl -L https://github.com/aelsabbahy/goss/releases/download/${GOSS_VERSION}/goss-linux-arm -o /usr/local/bin/goss \
 && chmod +rx /usr/local/bin/goss \
 && curl -L https://raw.githubusercontent.com/aelsabbahy/goss/${GOSS_VERSION}/extras/dgoss/dgoss -o /usr/local/bin/dgoss \
 && chmod +rx /usr/local/bin/dgoss \
# && curl -L https://raw.githubusercontent.com/aelsabbahy/goss/${GOSS_VERSION}/extras/dcgoss/dcgoss -o /usr/local/bin/dcgoss \
# Temp fix for dcgoss invalid junit output --> PR pending https://github.com/aelsabbahy/goss/pull/550
#-- && curl -L https://raw.githubusercontent.com/officerJones/goss/master/extras/dcgoss/dcgoss -o /usr/local/bin/dcgoss \
 && curl -L https://raw.githubusercontent.com/officerJones/goss/correcting_remove_container/extras/dcgoss/dcgoss -o /usr/local/bin/dcgoss \
 && chmod +rx /usr/local/bin/dcgoss

ENV GOSS_FILES_STRATEGY=cp

# Generate keys
RUN ssh-keygen -A \
# Set user jenkins to the image
 && groupadd -g 1000 1000 \
 && useradd -c "Jenkins user" -d /home/jenkins -u 1000 -g 1000 -m jenkins \
 && echo "jenkins:jenkins" | chpasswd \
 && groupadd docker -g 995 \
 && usermod -a -G 995 jenkins

# Add the ssh configuration
ADD ./ssh_config /etc/ssh/sshd_config

# Standard SSH port
EXPOSE 22

# Default command
CMD ["/usr/sbin/sshd", "-D"]