FROM jenkins/jenkins:latest-jdk11

USER root

# Install system dependencies securely with cleanup
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        lsb-release \
        python3-pip \
        curl \
        gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add Docker's official GPG key
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg

# Add Docker repository securely
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" > \
    /etc/apt/sources.list.d/docker.list

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Jenkins plugins with latest compatible versions
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"

# Drop back to jenkins user for safety
USER jenkins
