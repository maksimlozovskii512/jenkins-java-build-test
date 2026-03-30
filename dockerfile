FROM jenkins/jenkins:lts-jdk17

USER root

RUN apt-get update && apt-get install -y \
    curl git unzip tar ca-certificates gnupg lsb-release \
    && rm -rf /var/lib/apt/lists/*

ARG MAVEN_VERSION=3.9.9

RUN set -eux; \
    curl -fL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -o maven.tar.gz; \
    tar -xzf maven.tar.gz -C /opt/; \
    ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven; \
    rm maven.tar.gz; \
    chown -R jenkins:jenkins /opt/apache-maven-${MAVEN_VERSION}

ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

RUN jenkins-plugin-cli --plugins \
    git \
    workflow-aggregator \
    pipeline-maven \
    docker-workflow \
    credentials-binding

USER jenkins