#!/usr/bin/env bash
set -euo pipefail

# Validate required environment variables
: "${AWS_REGION:?AWS_REGION is required}"
: "${CLUSTER_NAME:?CLUSTER_NAME is required}"
: "${DEPLOY_NAME:?DEPLOY_NAME is required}"
: "${DEPLOY_CHART_PATH:?DEPLOY_CHART_PATH is required}"
: "${TIMEOUT:?TIMEOUT is required}"

# Login to Kubernetes Cluster.
if [ -n "${CLUSTER_ROLE_ARN:-}" ]; then
    aws eks \
        --region "${AWS_REGION}" \
        update-kubeconfig --name "${CLUSTER_NAME}" \
        --role-arn="${CLUSTER_ROLE_ARN}"
else
    aws eks \
        --region "${AWS_REGION}" \
        update-kubeconfig --name "${CLUSTER_NAME}"
fi

# Helm Deployment — build the command as an array to safely handle special characters.
UPGRADE_ARGS=(
    upgrade --install
    --kubeconfig /github/home/.kube/config
    --wait
    --timeout "${TIMEOUT}"
)

for config_file in ${DEPLOY_CONFIG_FILES//,/ }; do
    UPGRADE_ARGS+=(-f "${config_file}")
done

if [ -n "${DEPLOY_NAMESPACE:-}" ]; then
    UPGRADE_ARGS+=(-n "${DEPLOY_NAMESPACE}")
fi

if [ -n "${DEPLOY_VALUES:-}" ]; then
    UPGRADE_ARGS+=(--set "${DEPLOY_VALUES}")
fi

UPGRADE_ARGS+=("${DEPLOY_NAME}" "${DEPLOY_CHART_PATH}")

echo "Executing: helm ${UPGRADE_ARGS[*]}"
helm "${UPGRADE_ARGS[@]}"
