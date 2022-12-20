#!/bin/bash
set -eu

VERSION="${1}"
sed -i -b -e "s/^version:.*/version: ${VERSION}/g" pubspec.yaml
git commit -am "Version ${VERSION}"
git tag "v${VERSION}"
