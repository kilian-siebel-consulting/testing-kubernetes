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

sudo kubectl apply -f ${TARGET_DIR}
