#!/usr/bin/env bash
set -euo pipefail

TG_ARN="$1"
TIMEOUT_SECONDS="${2:-600}"

end=$((SECONDS + TIMEOUT_SECONDS))

while (( SECONDS < end )); do
  states=$(aws elbv2 describe-target-health \
    --target-group-arn "$TG_ARN" \
    --query "TargetHealthDescriptions[*].TargetHealth.State" \
    --output text)

  if [[ -n "$states" ]] && ! grep -qv "healthy" <<< "$states"; then
    echo "OK: all targets healthy: $states"
    exit 0
  fi

  echo "Waiting... states: ${states:-<none>}"
  sleep 10
done

echo "ERROR: targets not healthy within ${TIMEOUT_SECONDS}s"
exit 1
