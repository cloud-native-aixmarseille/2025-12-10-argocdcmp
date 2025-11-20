#!/bin/bash

set -eu -o pipefail
set -x

helm repo add traefik https://traefik.github.io/charts
helm repo update

helm upgrade traefik traefik/traefik \
  --install \
  --wait \
  --namespace traefik \
  --create-namespace \
  -f values.yaml \
  --version 37.3.0
