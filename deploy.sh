#!/usr/bin/env bash

TAG=${1}
K8S_DIR=./conf/k8s
TARGET_DIR=${K8S_DIR}/.generated
mkdir -p ${TARGET_DIR}
export BUILD_NUMBER=${TAG}
for f in ./conf/k8s/*.yaml
do
  envsubst < $f > "${TARGET_DIR}/$(basename $f)"
done

gcloud container clusters get-credentials cluster-1 --zone europe-west1-d --project testing-145512
kubectl apply -f ${TARGET_DIR}
