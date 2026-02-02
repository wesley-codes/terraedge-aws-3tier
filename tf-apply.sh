#!/usr/bin/env bash
set -euo pipefail

# Files
PLAN_BIN="plan.tfplan"      # binary plan file (Terraform uses this to apply)
PLAN_TXT="plan.txt"          # human-readable plan text
OUTPUTS_JSON="outputs.json" # structured outputs
OUTPUTS_TXT="outputs.txt"   # readable outputs

# 1) Create the plan (binary)
terraform plan -out="$PLAN_BIN"

# 2) Save a readable version of the plan to plan.tf
terraform show -no-color "$PLAN_BIN" > "$PLAN_TXT"

# 3) Apply exactly what was planned
terraform apply -auto-approve "$PLAN_BIN"

# 4) Wait for target group to become healthy
TG_ARN="$(terraform output -raw target_group_arn)"
./wait-for-tg-healthy.sh "$TG_ARN"

# 5) Save outputs to files (json + readable)
terraform output -json > "$OUTPUTS_JSON"
terraform output -no-color > "$OUTPUTS_TXT"

# 6) Wait for ASG instances to be running before printing
max_attempts=30
sleep_seconds=10
attempt=1
while true; do
  # Refresh state to pick up instance lifecycle changes
  terraform apply -refresh-only -auto-approve >/dev/null

  if python3 - <<'PY'
import json, subprocess, sys
p = subprocess.run(["terraform","output","-json","asg_ec2_details"], capture_output=True, text=True)
if p.returncode != 0:
    sys.exit(1)
data = json.loads(p.stdout or "{}")
if not data:
    sys.exit(1)
states = [v.get("instance_state") for v in data.values()]
if all(s == "running" for s in states):
    sys.exit(0)
sys.exit(1)
PY
  then
    break
  fi

  if [ "$attempt" -ge "$max_attempts" ]; then
    echo "Warning: instances not all running after $((max_attempts * sleep_seconds))s; printing current output."
    break
  fi

  attempt=$((attempt + 1))
  sleep "$sleep_seconds"
done

# 7) Echo the ASG EC2 details for quick verification
terraform output -no-color asg_ec2_details

echo "Saved:"
echo "  - $PLAN_TXT"
echo "  - $OUTPUTS_JSON"
echo "  - $OUTPUTS_TXT"
