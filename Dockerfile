FROM public.ecr.aws/docker/library/python:3.11-slim-bookworm

ENV HELM_VERSION=v3.20.1 \
    KUBECTL_VERSION=v1.33.9 \
    AWSCLI_VERSION=2.24.19

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl wget git unzip gnupg && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o /tmp/awscliv2.zip && \
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip.sig" -o /tmp/awscliv2.zip.sig && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip /tmp/awscliv2.zip.sig

# Install Helm with checksum verification
RUN wget -qO /tmp/helm.tar.gz "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    wget -qO /tmp/helm.tar.gz.sha256sum "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz.sha256sum" && \
    sha256sum -c /tmp/helm.tar.gz.sha256sum && \
    tar -xzO -f /tmp/helm.tar.gz linux-amd64/helm > /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm /tmp/helm.tar.gz /tmp/helm.tar.gz.sha256sum

# Install kubectl with checksum verification
RUN curl -fsSLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256" -o kubectl.sha256 && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    rm kubectl.sha256

# Install helm-secrets plugin
RUN helm plugin install https://github.com/jkroepke/helm-secrets --version v4.6.2

COPY deploy.sh /usr/local/bin/deploy
RUN chmod +x /usr/local/bin/deploy

CMD ["deploy"]
