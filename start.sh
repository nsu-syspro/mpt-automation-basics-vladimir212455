#!/sh
APP_NAME=$(jq -r .name config.json)
exec "./build/$APP_NAME" "$@"
