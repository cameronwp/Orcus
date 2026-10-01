#!/bin/bash

set ${SET_X:+-x} -eou pipefail

# VERSION should just be the date, but it might not have been set
version_date=${VERSION}
if [ -z "${VERSION}" ]; then
  version_date=$(date +%Y%m%d)
fi

# assigned separately so set -e catches a failure
fedora_ver=$(rpm -E %fedora)

# image-tag must be a tag CI actually pushes; ublue helpers build rebase refs from it
jq -n \
  --arg base "${BASE_IMAGE}" \
  --arg fedora "${fedora_ver}" \
  '{
    "image-name": "orcus",
    "image-flavor": "kinoite-main",
    "image-vendor": "cameronwp",
    "image-ref": "ostree-image-signed:docker://ghcr.io/cameronwp/orcus",
    "image-tag": "latest",
    "base-image-name": $base,
    "fedora-version": $fedora
  }' >/usr/share/ublue-os/image-info.json

echo "BUILD_ID=\"latest.${version_date}\"" >>/usr/lib/os-release
sed -i "s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME=\"${IMAGE}\"|" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"https://github.com/cameronwp/${IMAGE}\"|" /usr/lib/os-release
echo "IMAGE_ID=\"${IMAGE}\"" >>/usr/lib/os-release
echo "IMAGE_VERSION=\"${version_date}\"" >>/usr/lib/os-release
sed -i "s|^LOGO=.*|LOGO=\"${IMAGE}\"|" /usr/lib/os-release
sed -i "s|^OSTREE_VERSION=.*|OSTREE_VERSION=\"${version_date}\"|" /usr/lib/os-release
sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"$(echo "${IMAGE^}" | cut -d - -f1) (Version: ${version_date} / FROM ${BASE_IMAGE^} ${fedora_ver})\"|" /usr/lib/os-release
sed -i "s|^VERSION=.*|VERSION=\"${fedora_ver}.${version_date} (${BASE_IMAGE^})\"|" /usr/lib/os-release

cat /usr/lib/os-release