#!/bin/bash

SCRIPT_PATH=`dirname "$0"`
SPEC_PATH=$SCRIPT_PATH/../schemas
OUT_PATH=$SCRIPT_PATH/../tmp

# validate first
openapi-generator-cli validate -i "$SPEC_PATH/isbm_complete.yml" || exit

# Regenerates the ruby client server from the OpenAPI specification.
openapi-generator-cli generate -i "$SPEC_PATH/isbm_complete.yml" -g ruby --config "${SCRIPT_PATH}/ruby_client_conf.json" -o "$OUT_PATH/client"

# Regenerate the notification components into a temporary folder
# we only keep the Notification model in the client adaptor as it 
# has a minimal, custom server so that it can receive notifications.
openapi-generator-cli generate -i "$SPEC_PATH/notification_service.yml" -g ruby --config "${SCRIPT_PATH}/ruby_client_conf.json" -o "$OUT_PATH/notification"
