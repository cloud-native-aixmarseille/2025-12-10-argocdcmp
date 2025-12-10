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
	RFACT="$(curl -qsS "https://uselessfacts.jsph.pl/api/v2/facts/${ARGOCD_ENV_FACTID}" | jq -r '.text')"
fi

echo "+ rendering phase"
RTS="$(date +%s)"
cat fortune.yaml | sed -e "s/<RFACT>/${RFACT}/" -e "s/<RTS>/${RTS}/" >&3

echo "+ finished"
exit 0
