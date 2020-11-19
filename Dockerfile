FROM debian:stable-slim

WORKDIR /ansible
COPY ./requirements.txt .

RUN apt-get update -y && apt-get install -y \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        postgresql-client \
        python3 \
        python3-dev \
        python3-pip \
        cron \
        git \
        wget \
        unzip \
        && apt-get autoremove -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get autoclean

RUN pip3 install --no-cache-dir --upgrade pip cffi && \
    pip3 install --no-cache-dir -r requirements.txt

RUN mkdir -p ~/.ssh && mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

ENV TERRAFORM_VERSION=0.13.5
RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm -rf /tmp/*
