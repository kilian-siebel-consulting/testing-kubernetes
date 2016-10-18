#!/usr/bin/env bash
echo "TRAVIS_BUILD_NUMBER: ${TRAVIS_BUILD_NUMBER}"
K8S_DIR=./conf/k8s
TARGET_DIR=${K8S_DIR}/.generated
mkdir -p ${TARGET_DIR}
export BUILD_NUMBER=${1}
for f in ./conf/k8s/*.yaml
do
  envsubst < $f > "${TARGET_DIR}/$(basename $f)"
done

gcloud container clusters get-credentials ${GC_CLUSTER_NAME} --zone ${GC_COMPUTE_ZONE} --project ${GC_PROJECT_NAME}

# quick and dirty recreating configmaps
kubectl delete --namespace=testing-kubernetes configmap nginx-config
kubectl create --namespace=testing-kubernetes configmap nginx-config --from-file=${K8S_DIR}/../nginx/default.conf

kubectl apply -f ${TARGET_DIR}
