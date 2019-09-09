#!/bin/bash
set -eu

switch_to_admin

# Create cluster rolebinding for teller serviceaccount
kubectl apply -f "${ROOT_PATH}/scripts/helm.yml"

## install tell in insecure (for testing)
helm init \
    --service-account tiller \
    --node-selectors "beta.kubernetes.io/os=linux"
