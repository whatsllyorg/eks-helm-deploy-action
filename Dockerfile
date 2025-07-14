# Use a more recent base image - buster is getting old
FROM public.ecr.aws/docker/library/python:3.11-slim-bookworm

# Install dependencies including git for helm plugins
RUN apt-get update && \
    apt-get install -y curl wget git && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN pip install --no-cache-dir awscli

# Install Helm
RUN wget -O- https://get.helm.sh/helm-v3.12.3-linux-amd64.tar.gz | \
    tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install helm-secrets plugin
RUN helm plugin install https://github.com/jkroepke/helm-secrets --version v4.2.2

COPY deploy.sh /usr/local/bin/deploy
RUN chmod +x /usr/local/bin/deploy

CMD ["deploy"]