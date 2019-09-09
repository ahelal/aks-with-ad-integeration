#!/bin/bash
set -ue

# shellcheck source=scripts/_sp_server.sh
. "${ROOT_PATH}"/scripts/_sp_server.sh

# shellcheck source=scripts/_sp_client.sh
. "${ROOT_PATH}"/scripts/_sp_client.sh

echo "> Create a resource group the AKS cluster ${RESOURCE_GROUP} in ${LOCATION}"
az group create --name "${RESOURCE_GROUP}" --location "${LOCATION}" > /dev/null

NODE_COUNT=${NODE_COUNT:-1}

# Get server/client app ID
get_server_app_id
get_client_app_id
SERVER_APP_PASSWORD="$(cat "${SERVER_APP_PASSWORD_FILE}")"

echo "> Create the AKS cluster with Azure AD. This will take some time ..."
az aks create \
  --resource-group "${RESOURCE_GROUP}" \
  --name "${AKS_NAME}" \
  --node-count "${NODE_COUNT}" \
  --generate-ssh-keys \
  --aad-server-app-id "${SERVER_APP_ID}" \
  --aad-server-app-secret "${SERVER_APP_PASSWORD}" \
  --aad-client-app-id "${CLIENT_APP_ID}" \
  --aad-tenant-id "${TENANT_ID}" > /dev/null

echo "> Enjoy AKS ..."