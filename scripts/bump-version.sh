#!/bin/bash
set -eu

VERSION="${1}"
sed -i -b -e "s/^version:.*/version: ${VERSION}/g" pubspec.yaml
sed -i -b -e "s/\[Unreleased\]/\[${VERSION}\] - $(date -I)/g" CHANGELOG*.md

git commit -am "Version ${VERSION}"
git tag "v${VERSION}"
