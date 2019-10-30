#!/bin/bash

FILE=$(curl -sSL https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml)

IMAGES=$( echo "${FILE}" | grep gcr.io |awk '{print $2}')

VAR="v0.0.1"

for img in $IMAGES
do
    echo $img
    toimgs=$(echo $img | sed 's;gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/;docker.io/gsmlg/pipline-;g')
    toimg="$(echo $toimgs | awk -F'@' '{print $1}'):$VAR"
    docker pull $img
    docker tag "$img" "$toimg"
    docker push "$toimg"
done

#echo "${FILE}" | sed 's;gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/;docker.io/gsmlg/pipline-;g'

UPDATED=$( echo "${FILE}" | sed 's;gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/;docker.io/gsmlg/pipline-;g' )

echo "$UPDATED" > updated.yaml

echo "$UPDATED"

