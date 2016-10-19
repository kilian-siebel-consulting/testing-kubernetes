#!/usr/bin/env bash

K8S_DIR=./conf/k8s
TARGET_DIR=${K8S_DIR}/.generated
mkdir -p ${TARGET_DIR}
for f in ./conf/k8s/*.yaml
do
  envsubst < $f > "${TARGET_DIR}/$(basename $f)"
done

kubectl create namespace testing-kubernetes
# quick and dirty recreating configmaps
kubectl delete --namespace=testing-kubernetes configmap nginx-config
kubectl create --namespace=testing-kubernetes configmap nginx-config --from-file=${K8S_DIR}/../nginx/default.conf

kubectl apply -f ${TARGET_DIR}
