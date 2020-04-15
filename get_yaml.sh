#!/bin/bash

curl -sSL https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml -o tekton.yaml

curl -sSL https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml -o tekton-dashboard.yaml

curl -sSL https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml > tekton-trigger.yaml




