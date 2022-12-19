#!/bin/bash
set -eu

APP='tiny_vcc.app'
DMG='tiny-vcc.dmg'

rm -f "${DMG}"

create-dmg \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "${APP}" 200 190 \
  --hide-extension "${APP}" \
  --app-drop-link 600 185 \
  "${DMG}" \
  "build/macos/Build/Products/Release/${APP}"
