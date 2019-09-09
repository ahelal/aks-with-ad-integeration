#!/bin/bash
set -eu

echo "> Created Active direcotry group ${AD_GROUP_NAME}"
GROUP_OBJECT_ID="$(az ad group create --display-name "${AD_GROUP_NAME}" --mail-nickname "${AD_GROUP_NAME}" -o tsv --query objectId)"

CURRENT_USER_OBJECT_ID="$(az ad signed-in-user show -o tsv --query objectId)"

if ! az ad group member list -g "${GROUP_OBJECT_ID}" | grep "${CURRENT_USER_OBJECT_ID}" > /dev/null; then
    echo "> Adding you to ${AD_GROUP_NAME}"
    az ad group member add -g "${GROUP_OBJECT_ID}" --member-id "${CURRENT_USER_OBJECT_ID}"
fi

switch_to_admin

if kubectl create namespace "${AD_NAMESPACE}"; then
    echo "> Created namespace $AD_NAMESPACE"
fi

if kubectl create role test_pod_writer \
                  --verb create,get,list,watch \
                  --resource pods \
                  --namespace "${AD_NAMESPACE}"; then
    echo "> Created Role 'pod-writer' in $AD_NAMESPACE resource pods create,get,list,watch"
fi


if kubectl create rolebinding pod-writer-binding \
                             --role "test_pod_writer" \
                             --group "${GROUP_OBJECT_ID}" \
                             --namespace "${AD_NAMESPACE}"; then
    echo "> Created Role 'pod-writer' in $AD_NAMESPACE resource pods create,get,list,watch"
fi
