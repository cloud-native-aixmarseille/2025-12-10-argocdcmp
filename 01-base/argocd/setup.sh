#!/bin/bash

set -eu -o pipefail

echo "+ installing argocd core"
helm upgrade argocd oci://ghcr.io/argoproj/argo-helm/argo-cd \
  --install \
  --namespace argocd \
  --create-namespace \
  -f core-values.yaml \
  --version 9.1.3

echo "+ addig ingress route"
kubectl apply -f ingress-route.yaml

echo "+ installing argocd app-of-apps"
helm upgrade argocd-apps oci://ghcr.io/argoproj/argo-helm/argocd-apps \
  --install \
  -f app-values.yaml \
  --version 2.0.2
