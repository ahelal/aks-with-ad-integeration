# AKS AD

## Intro

This repo hosts scripts to spin an AKS cluster in Azure with active directory integeratio and setup Helm.
This repo is designed for demos.

## pre-requisites

* [AZ CLI](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

Optional

* [helm](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Install

1. Clone the repo. 
2. `cp vars.example.sh vars.sh`
3. customize `vars.sh`

### Deploy AKS

```sh
./aksad.sh up
```

### Deploy helm with RBAC support

```sh
./aksad.sh helm_init
```

### Testing helm

You can deploy anything you like with helm or use the small test

```sh
# Deploying concourse on AKS with help
./aksad.sh concourse
# Test you can curl the API you should wait a bit until everything is up & running
./aksad.sh test_concourse
```

### Setup Azure AD Group & Kubenetes role/bindings

This will create an Azure AD group as defined in `$AD_GROUP_NAME` in `var.sh`. You current user logged in user in AZ cli will be added
as a member.
A kuberetes role/role bind is created and attached to the AZ group. The role will allow you to only managed pods in `$ÀD_NAMESPACE`namespace as defined in `vars.sh`

```sh
./aksad.sh group_setup
# after a couple of min
kubectl config use-context <CLUSTERNAME>
kubectl get pods
# you need to login to get the token
# You shoud get Error from server (Forbidden)

kubectl get pods -n <NAMESPACE IN VARS>
```

### Delete AKS cluster

```sh
# Deletes AKS cluster with resource group, server, client, SP and AD group defined in var.sh
# Attemtps to do a complete clean removal
./aksad.sh destroy
```
