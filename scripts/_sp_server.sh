#!/bin/bash
set -ue

if ! [ -f "${SERVER_APP_PASSWORD_FILE}" ]; then
    env LC_CTYPE=C tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 16 > "${SERVER_APP_PASSWORD_FILE}"
fi
SERVER_APP_PASSWORD="$(cat "${SERVER_APP_PASSWORD_FILE}")"

echo "> Creating the Azure AD application https://${AKS_NAME}-server"
SERVER_APP_ID=$(az ad app create \
                      --display-name "${AKS_NAME} server application" \
                      --identifier-uris "https://${AKS_NAME}-server" \
                      --password "${SERVER_APP_PASSWORD}" \
                      --query appId -o tsv)

echo "> Update the application group memebership claims"
az ad app update --id "${SERVER_APP_ID}" --set groupMembershipClaims=All

echo "> Creating a service principal for the Azure AD application"
if ! az ad sp create --id "${SERVER_APP_ID}" > /dev/null; then
    echo "Server service prinicple already created skipping "
fi

echo "> Add permissions for the Azure AD app to read directory data, sign in and read user profile, and read directory data"
az ad app permission add \
    --id "${SERVER_APP_ID}" \
    --api 00000003-0000-0000-c000-000000000000 \
    --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope 06da0dbc-49e2-44d2-8312-53f166ab848a=Scope 7ab1d382-f21e-4acd-a863-ba3e13f7da61=Role > /dev/null

## should be replaced with a loop and check instead 
echo "> Sleeping for 50 seconds ..."
sleep 50

# You must be the Azure AD tenant admin for these steps to successfully complete
echo "> Grant permissions for the permissions assigned in the previous step"
az ad app permission grant --id "${SERVER_APP_ID}" --api 00000003-0000-0000-c000-000000000000 > /dev/null
az ad app permission admin-consent --id  "${SERVER_APP_ID}" > /dev/null

echo "${SERVER_APP_ID}" > "${SERVER_APP_ID_FILE}"