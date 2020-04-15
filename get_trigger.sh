#!/bin/bash

FILE=$(curl -sSL https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml)

IMAGES=$( echo "${FILE}" | grep gcr.io |awk '{print $2}')

VAR="v0.4.0"

for img in $IMAGES
do
    echo $img
    toimgs=$(echo $img | sed 's;gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/;docker.io/gsmlg/pipeline-trigger-;g')
    toimg="$(echo $toimgs | awk -F'@' '{print $1}'):$VAR"
    echo $toimgs
    echo $toimg
    docker pull $img
    docker tag "$img" "$toimg"
    docker push "$toimg"
done

#echo "${FILE}" | sed 's;gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/;docker.io/gsmlg/pipeline-;g'

UPDATED=$( echo "${FILE}" | sed 's;gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/;docker.io/gsmlg/pipeline-trigger-;g')

echo "$UPDATED" > updated_trigger.yaml

echo "$UPDATED"


