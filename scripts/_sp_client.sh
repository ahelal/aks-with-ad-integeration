#!/bin/bash
set -eu

echo "> Create the Azure AD client application"
CLIENT_APP_ID=$(az ad app create \
                        --display-name "${AKS_NAME} client application" \
                        --native-app \
                        --reply-urls "https://${AKS_NAME}-client" \
                        --query appId -o tsv)

echo " > Create a service principal for the client application"
if ! az ad sp create --id "${CLIENT_APP_ID}" > /dev/null; then
    echo "> Client service prinicple already created skipping"
fi

echo "> Get the oAuth2 ID for the server app to allow authentication flow"
OAUTH_PERMISSION_ID=$(az ad app show --id "${SERVER_APP_ID}" --query "oauth2Permissions[0].id" -o tsv)

echo "> Assign permissions for the client and server applications to communicate with each other"
az ad app permission add --id "${CLIENT_APP_ID}" --api "${SERVER_APP_ID}" --api-permissions "${OAUTH_PERMISSION_ID}"=Scope > /dev/null
az ad app permission grant --id "${CLIENT_APP_ID}" --api "${SERVER_APP_ID}" > /dev/null

echo "${CLIENT_APP_ID}" > "${CLIENT_APP_ID_FILE}"
