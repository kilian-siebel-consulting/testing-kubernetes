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

# quick and dirty recreating configmaps
kubectl delete --namespace=testing-kubernetes configmap nginx-config
kubectl create --namespace=testing-kubernetes configmap nginx-config --from-file=${K8S_DIR}/../conf/nginx/default.conf

kubectl apply -f ${TARGET_DIR}
