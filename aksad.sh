#!/bin/bash
set -eu
ROOT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
export ROOT_PATH

# shellcheck source=scripts/_common.sh
source "${ROOT_PATH}/scripts/_common.sh"

case "${1}" in
up)
    . "${ROOT_PATH}/scripts/_up.sh"
    . "${ROOT_PATH}/scripts/_get-credentials-aks.sh"
    ;;
destroy)
    . "${ROOT_PATH}/scripts/_destroy.sh"
    ;;
helm_init)
    . "${ROOT_PATH}/scripts/_helm-init.sh"
    ;;
concourse)
    helm fetch stable/concourse --untar --untardir "${ROOT_PATH}/.temp/"
    helm upgrade -i concourse "${ROOT_PATH}/.temp/concourse"
    ;;
test_concourse)
    . "${ROOT_PATH}/scripts/run-test.sh"
    ;;
group_setup)
    . "${ROOT_PATH}/scripts/_group_setup.sh"
    ;;
*)
    echo "Unknown argument '$1' supported option [ up | destroy | helm-init | concourse-deploy "
    ;;
esac