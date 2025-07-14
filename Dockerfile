FROM public.ecr.aws/docker/library/python:3.8-slim-buster

# Install the toolset with better error handling
RUN apt-get update -y && \
    apt-get install -y curl && \
    pip install --no-cache-dir awscli && \
    curl --retry 3 https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.25.16/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    helm plugin install https://github.com/jkroepke/helm-secrets --version v4.2.2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY deploy.sh /usr/local/bin/deploy

RUN chmod +x /usr/local/bin/deploy

CMD ["deploy"]