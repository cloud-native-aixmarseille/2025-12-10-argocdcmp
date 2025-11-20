#!/bin/bash

# save stdout descriptor
exec 3>&1
# redirect all output to stderr
exec 1>&2

SOURCE_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

echo "meetup-cmp plugin - ${ARGOCD_APP_NAME}"

echo "+ init phase"
if [ -z "${ARGOCD_ENV_FACTID}" ]; then
	echo "ARGOCD_ENV_FACTID is unset using a random fact ..."
	RFACT="$(curl -qsS 'https://uselessfacts.jsph.pl/api/v2/facts/random' | jq -r '.text')"
else
	echo "ARGOCD_ENV_FACTID is ${ARGOCD_ENV_FACTID} using it as source fact ..."
	RFACT="$(http "https://uselessfacts.jsph.pl/api/v2/facts/${ARGOCD_ENV_FACTID}" | jq -r '.text')"
fi

echo "+ rendering phase"
/usr/local/bin/helm template . \
	--name-template "${ARGOCD_APP_NAME:-unknown}" \
	--namespace "${ARGOCD_APP_NAMESPACE:-default}" \
	--kube-version "${KUBE_VERSION:-1.31.0}" \
	>all.yaml
sed -i'' -e "s/<RFACT>/${RFACT}/" all.yaml

echo "+ finished"
exit 0
