#!/usr/bin/env bash

TAG=${1}
export BUILD_NUMBER=${TAG}
for f in ./conf/k8s/*.yaml
do
  envsubst < $f > "./conf/k8s/.generated/$(basename $f)"
done

kubectl apply -f ./conf/k8s/.generated/
