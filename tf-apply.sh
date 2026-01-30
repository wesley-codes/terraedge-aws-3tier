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

# 4) Save outputs to files (json + readable)
terraform output -json > "$OUTPUTS_JSON"
terraform output -no-color > "$OUTPUTS_TXT"

echo "Saved:"
echo "  - $PLAN_TXT"
echo "  - $OUTPUTS_JSON"
echo "  - $OUTPUTS_TXT"
