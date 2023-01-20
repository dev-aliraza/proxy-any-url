#!/bin/sh

# Validating JSON
if $(echo "$PROXY_URL_JSON" | jq -e . >/dev/null 2>&1); then
    :
else
    echo "Failed to parse JSON, or got false/null"
    exit 1
fi

# Parsing JSON
items=$(echo "$PROXY_URL_JSON" | jq -c -r '.[]')
config_output=""

for item in ${items}; do
    key=$(echo $item | jq 'keys[0]')
    key=$(echo "$key" | tr -d '"')
    value=$(echo $item | jq ."\"$key\"")
    value=$(echo "$value" | tr -d '"')
    config_output=$(echo "$config_output
    location /$key {
        proxy_pass \"$value\";
    }
")
done

# /etc/nginx/conf.d/default.conf
echo "server {
    listen       0.0.0.0:$PROXY_PORT;
    server_name  _;
    $config_output
}" > /etc/nginx/conf.d/default.conf

# runing nginx
nginx -g "daemon off;"