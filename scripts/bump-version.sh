#!/bin/bash
set -eu

VERSION="${1}"
sed -i -b -e "s/^version:.*/version: ${VERSION}/g" pubspec.yaml
sed -i -b -e "s/\[Unreleased\]/\[${VERSION}\] - $(date -I)/g" CHANGELOG*.md
sed -i -b -e "s/\"ProductVersion\" = \".*\"/\"ProductVersion\" = \"8:${VERSION}\"/g" installer/TinyVccInstaller/TinyVccInstaller/TinyVccInstaller.vdproj

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
    pwsh.exe -ExecutionPolicy RemoteSigned -File scripts/update-product-code.ps1
fi

git commit -am "Version ${VERSION}"
git tag "v${VERSION}"
