#!/bin/bash

# shellcheck disable=SC1091
source "${ROOT_PATH}/vars.sh"

az account set --subscription "${SUBSCRIPTION}" > /dev/null

# Get the Azure AD tenant ID to integrate with the AKS cluster
TENANT_ID=$(az account show --query tenantId -o tsv)
export TENANT_ID

mkdir -p "${ROOT_PATH}/.temp"
SERVER_APP_PASSWORD_FILE="${ROOT_PATH}/.temp/.random_pass"
export SERVER_APP_PASSWORD_FILE
SERVER_APP_ID_FILE="${ROOT_PATH}/.temp/.server_app_id"
export SERVER_APP_ID_FILE
CLIENT_APP_ID_FILE="${ROOT_PATH}/.temp/.client_app_id"
export CLIENT_APP_ID_FILE
# _get-credentials-aks.sh
get_server_app_id(){
    if ! [ -f "${SERVER_APP_ID_FILE}" ]; then
        echo "> Server ID file not foud in ${SERVER_APP_ID_FILE}"
        exit 1
    fi
    SERVER_APP_ID="$(cat "${SERVER_APP_ID_FILE}")"
    export SERVER_APP_ID
}

get_client_app_id(){
    if ! [ -f "${CLIENT_APP_ID_FILE}" ]; then
        echo "> Client ID file not foud in ${CLIENT_APP_ID_FILE}"
        exit 1
    fi
    CLIENT_APP_ID="$(cat "${CLIENT_APP_ID_FILE}")"
    export CLIENT_APP_ID
}

switch_to_admin(){
    echo "> Switching to kubectl ADMIN creds ...."
    kubectl config use-context "${AKS_NAME}-admin"
}