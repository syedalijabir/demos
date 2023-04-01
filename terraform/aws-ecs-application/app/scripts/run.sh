#!/bin/sh
set -x
set +e

metadata=$(curl --max-time 1 -s ${ECS_CONTAINER_METADATA_URI_V4}/task)
if [[ $?=='0' ]]; then
  az=$(echo "$metadata" | jq '.AvailabilityZone' | tr -d '"')
  export REGION=${az}
fi

set -e

python app.py
