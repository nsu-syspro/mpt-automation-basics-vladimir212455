#!/bin/sh
APP_NAME=$(jq -r .name /app/config.json)
exec "/app/build/$APP_NAME" "$@"