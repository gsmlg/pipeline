#!/bin/bash

FILE=$(curl -sSL https://github.com/kubernetes/test-infra/raw/master/prow/cluster/starter.yaml)

echo "$FILE" > prow.yaml

IMAGES=$( echo "${FILE}" | grep gcr.io |awk '{print $2}')

for img in $IMAGES
do
    echo $img
    toimg=$(echo $img | sed 's;gcr.io/k8s-prow/;podman.io/gsmlg/k8s-prow-;g')
    #echo $toimg
    podman pull $img
    podman tag "$img" "$toimg"
    podman push "$toimg"
done

UPDATED=$( echo "${FILE}" | sed 's;gcr.io/k8s-prow/;podman.io/gsmlg/k8s-prow-;g' )

echo "$UPDATED" > updated_prow.yaml

#echo "$UPDATED"

