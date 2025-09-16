#!/bin/bash

set ${SET_X:+-x} -eou pipefail

# VERSION should just be the date, but it might not have been set
version_date=${VERSION}
if [ -z "${VERSION}" ]; then
  version_date=$(date +%Y%m%d)
fi

tee /usr/share/ublue-os/image-info.json <<'EOF'
{
  "image-name": "",
  "image-flavor": "",
  "image-vendor": "cameronwp",
  "image-ref": "ostree-image-signed:docker://ghcr.io/cameronwp/orcus",
  "image-tag": "",
  "base-image-name": "",
  "fedora-version": ""
}
EOF

cat <<<"$(jq ".\"image-name\" |= \"orcus\" |
              .\"image-flavor\" |= \"kinoite-main\" |
              .\"image-vendor\" |= \"cameronwp\" |
              .\"image-ref\" |= \"ostree-image-signed:docker://ghcr.io/cameronwp/orcus\" |
              .\"image-tag\" |= \"${IMAGE}${version_date}\" |
              .\"base-image-name\" |= \"${BASE_IMAGE}\" |
              .\"fedora-version\" |= \"$(rpm -E %fedora)\"" \
    </usr/share/ublue-os/image-info.json)" \
>/tmp/image-info.json
cp /tmp/image-info.json /usr/share/ublue-os/image-info.json

sed -i "s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME=\"${IMAGE}\"|" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"https://github.com/cameronwp/${IMAGE}\"|" /usr/lib/os-release
sed -i "s|^LOGO=.*|LOGO=\"${IMAGE}\"|" /usr/lib/os-release
echo "IMAGE_ID=\"${IMAGE}\"" >>/usr/lib/os-release
echo "IMAGE_VERSION=\"${version_date}\"" >>/usr/lib/os-release
sed -i "s|^OSTREE_VERSION=.*|OSTREE_VERSION=\'${VERSION}\'|" /usr/lib/os-release
sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"$(echo "${IMAGE^}" | cut -d - -f1) (Version: ${version_date} / FROM ${BASE_IMAGE^} $(rpm -E %fedora))\"|" /usr/lib/os-release
sed -i "s|^VERSION=.*|VERSION=\"${version_date} (${BASE_IMAGE^})\"|" /usr/lib/os-release

cat /usr/lib/os-release