FROM jenkins/jenkins:lts-jdk17

USER root

# Paquetes básicos + Docker CLI desde repos de Debian (simple y estable)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg wget \
      docker.io && \
    rm -rf /var/lib/apt/lists/*

# Maven (más simple: desde apt)
RUN apt-get update && \
    apt-get install -y --no-install-recommends maven && \
    rm -rf /var/lib/apt/lists/*

# Permisos (en Debian el grupo suele llamarse 'docker' cuando instalas docker.io)
RUN usermod -aG docker jenkins

USER jenkins