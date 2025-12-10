#!/bin/bash

set -eu -o pipefail

SCRIPTDIR="$(realpath $(dirname $0))"
ROOTDIR="$(realpath "${SCRIPTDIR}/..")"
export DIRENV_LOG_FORMAT=""

cd "${ROOTDIR}"
# shellcheck disable=SC1091
source ./scripts/demo-magic.sh

clear
direnv allow .envrc
eval "$(direnv export bash)"

#### start the magic ####

p "Setup our stack (argocd + traefik)"
pei "pushd 01-base; task; popd"
echo ""

p "Show the demo app 😉"
pei "code 01-base/argocd/app-values.yaml src/manifests/fortune.yaml"
echo ""

pe "open http://argocd.k8s.orb.local/"
pe "open https://github.com/cloud-native-aixmarseille/2025-12-10-argocdcmp"
echo ""

p "STEP-0 : the demo app"
p "sync it 🚀"
pei "open http://fortune.k8s.orb.local/"
echo ""

p "STEP-1 : add our argocd CMP plugin"
p "Open ./src/cmp-meetup"
p "build the image"
pe "pushd src/cmp-meetup; PLATFORM='linux/arm64' task -- --push; popd"
p "⚠️ note the image repo + tag + exact checksum"
p "add it to the argocd deployment"
p "show changes to manifests"
pei "code 01-base/argocd/core-values.yaml"
p "commit the changes"
pe "pushd 01-base; task argocd; popd"
p "refresh, show the diffs, sync in argocd and refresh the demo page"
p "NB: the fact displayed is random (check the script)"
echo ""

p "STEP-2 : use env params"
p "show changes to manifests"
pe "pushd 01-base; task argocd; popd"
p "commit the changes"
echo ""

p "STEP-3 : use auto discovery"
p "show changes to manifests"
pe "pushd 01-base; task argocd; popd"
p "commit the changes"
echo ""
