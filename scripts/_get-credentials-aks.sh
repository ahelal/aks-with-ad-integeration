#!/bin/bash

az aks get-credentials \
        --resource-group "${RESOURCE_GROUP}"\
        --name "${AKS_NAME}" \
        --admin
az aks get-credentials \
        --resource-group "${RESOURCE_GROUP}"\
        --name "${AKS_NAME}"