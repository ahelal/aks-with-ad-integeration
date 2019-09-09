#!/bin/bash
set -eu

read -r -p "  Are you sure you want to delete the aks cluster ? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        echo "> Deleting AKS Cluster ${AKS_NAME} (This might take a while)..."
        ;;
    *)
        echo "! Bye"
        exit 0
        ;;
esac

if az group delete -y --name "${RESOURCE_GROUP}"; then
    echo "> Deleted resource group ${RESOURCE_GROUP} in ${LOCATION}"
else
    echo "> Skipping resource group ${RESOURCE_GROUP} is already deleted"
fi

if az ad app delete --id="https://${AKS_NAME}-server"; then
    echo "> Deleted Server APP https://${AKS_NAME}-server"
else
    echo "> Skipping Server APP is already deleted"
fi

CLIENT_OBJECT_ID=$(az ad app list -o tsv --query "[?displayName=='akswithadk client application'].objectId")
if az ad app delete --id "${CLIENT_OBJECT_ID}"; then
    echo "> Deleted client APP"
else
    echo "> Skipping client APP is already deleted"
fi

echo "Deleting Service Princple"
az ad sp delete --id "$(az aks show -g "${RESOURCE_GROUP}"  -n "${AKS_NAME}}" --query servicePrincipalProfile.clientId -o tsv)"

if az ad group delete -g "${AD_GROUP_NAME}"; then
    echo "> Deleted group name"
fi



echo "> Deleted temp files"
rm -rf "${ROOT_PATH}/.temp/"
