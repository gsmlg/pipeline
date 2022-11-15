#!/bin/bash

export DOCKER=${DOCKER:-docker}

FILE=$(curl -sSL https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml)

IMAGES=$(echo "${FILE}" | grep gcr.io |awk '{print $2}'| sed 's;[",];;g')

VAR="v0.0.1"

echo "$IMAGES"
exit

for img in $IMAGES
do
    echo "Image ====>> $img"
    toimgs=$(echo $img | sed 's;gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/;docker.io/gsmlg/pipeline-;g')
    toimg="$(echo $toimgs | awk -F'@' '{print $1}')"
    echo "New Image ====> $toimg"
    $DOCKER pull $img
    $DOCKER tag "$img" "$toimg"
    $DOCKER push "$toimg"
done

#echo "${FILE}" | sed 's;gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/;docker.io/gsmlg/pipeline-;g'

UPDATED=$( echo "${FILE}" | sed 's;gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/;docker.io/gsmlg/pipeline-;g' )

echo "$UPDATED" > updated.yaml

#echo "$UPDATED"

