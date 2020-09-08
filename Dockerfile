from conda/miniconda3:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
        nano \
        git \
        wget \
        curl \
        zip \
        unzip \
        python-setuptools \
        python-dev \
        libkrb5-dev \
        libaio1 \
        libsm6 \
        libxext6 \
        iptables \
        libfontconfig1 \
        libxrender1 \
        openjdk-8-jdk \
        libsasl2-modules-gssapi-mit \
        python3-pip krb5-user -y && \
    apt-get clean

RUN apt install htop -y
RUN curl -fsSL https://code-server.dev/install.sh | sh

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update

COPY environment.yml .
RUN conda env create -f environment.yml
SHELL ["conda", "run", "-n", "hdfstest", "/bin/bash", "-c"]

RUN mkdir /workspace
ADD run.sh /workspace

WORKDIR /workspace
RUN cp /usr/local/envs/hdfstest/lib/libhdfs3.so /usr/local/envs/hdfstest/lib/libhdfs.so


ENTRYPOINT ["/bin/bash", "-c", "./run.sh"]
