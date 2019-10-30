#!/bin/bash

FILE=$(curl -sSL https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml)

IMAGES=$( echo "${FILE}" | grep gcr.io |awk '{print $2}')

for img in $IMAGES
do
    echo $img
    toimg=$(echo $img | sed 's;gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/;docker.io/gsmlg/pipline-;g')
    docker pull $img
    docker tag "$img" "$toimg"
    docker push "$toimg"
done

$UPDATED=$( echo "${FILE}" | sed 's;gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/;docker.io/gsmlg/pipline-;g' )

echo $UPDATED

