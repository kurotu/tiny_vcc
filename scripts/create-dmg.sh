#!/bin/bash
set -eu

APP_DIR="${1}"
APP="$(basename "${APP_DIR}")"
DMG="${2}"

rm -f "${DMG}"

create-dmg \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "${APP}" 200 190 \
  --hide-extension "${APP}" \
  --app-drop-link 600 185 \
  "${DMG}" \
  "${APP_DIR}"
