#!/usr/bin/bash

set ${SET_X:+-x} -eou pipefail

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

base_image="kinoite"
image_flavor="main"

# Branding
cat <<<"$(jq ".\"image-name\" |= \"orcus\" |
              .\"image-flavor\" |= \"${image_flavor}\" |
              .\"image-vendor\" |= \"cameronwp\" |
              .\"image-ref\" |= \"ostree-image-signed:docker://ghcr.io/cameronwp/orcus\" |
              .\"image-tag\" |= \"${IMAGE}${VERSION}\" |
              .\"base-image-name\" |= \"${base_image}\" |
              .\"fedora-version\" |= \"$(rpm -E %fedora)\"" \
    </usr/share/ublue-os/image-info.json)" \
>/tmp/image-info.json
cp /tmp/image-info.json /usr/share/ublue-os/image-info.json

sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"$(echo "${IMAGE^}" | cut -d - -f1) (Version: ${VERSION} / FROM ${BASE_IMAGE^} $(rpm -E %fedora))\"|" /usr/lib/os-release
sed -i "s|^VERSION=.*|VERSION=\"${VERSION} (${base_image^})\"|" /usr/lib/os-release
sed -i "s|^OSTREE_VERSION=.*|OSTREE_VERSION=\'${VERSION}\'|" /usr/lib/os-release
echo "IMAGE_ID=\"${IMAGE}\"" >>/usr/lib/os-release
echo "IMAGE_VERSION=\"${VERSION}\"" >>/usr/lib/os-release
