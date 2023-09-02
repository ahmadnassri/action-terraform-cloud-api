#!/bin/bash
set -euo pipefail

# set ORG & WORKSPACE from state file
TF_ORG=${INPUT_ORG:-$(jq -r '.backend.config.organization' < ${INPUT_STATE})}
TF_WORKSPACE=${INPUT_WORKSPACE:-$(jq -r '.backend.config.workspaces.name' < ${INPUT_STATE})}

echo ::debug::org set to ${TF_ORG}
echo ::debug::workspace set to ${TF_ORG}

function api {
  echo $(curl -s -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/vnd.api+json" https://app.terraform.io/api/v2/${1} | jq -c .data.attributes)
}

declare -A PREFIX
declare -A ENDPOINTS

PREFIX[ORG]="organization"
PREFIX[WORKSPACE]="workspace"

# endpoints we want to call
ENDPOINTS[ORG]="organizations/${TF_ORG}"
ENDPOINTS[WORKSPACE]="organizations/${TF_ORG}/workspaces/${INPUT_WORKSPACE}"

# props we want to export
# shellcheck disable=SC2034
ORG_PROPS=(
  "external-id"
  "created-at"
  "email"
  "session-timeout"
  "session-remember"
  "collaborator-auth-policy"
  "plan-expired"
  "plan-expires-at"
  "plan-is-trial"
  "plan-is-enterprise"
  "plan-identifier"
  "cost-estimation-enabled"
  "managed-resource-count"
  "send-passing-statuses-for-untriggered-speculative-plans"
  "allow-force-delete-workspaces"
  "assessments-enforced"
  "is-in-degraded-mode"
  "name"
  "saml-enabled"
  "fair-run-queuing-enabled"
  "owners-team-saml-role-id"
  "two-factor-conformant"
)

WORKSPACE_PROPS=(
  "allow-destroy-plan"
  "auto-apply"
  "auto-destroy-at"
  "auto-destroy-status"
  "environment"
  "locked"
  "name"
  "queue-all-runs"
  "speculative-enabled"
  "structured-run-output-enabled"
  "terraform-version"
  "working-directory"
  "global-remote-state"
  "updated-at"
  "resource-count"
  "apply-duration-average"
  "plan-duration-average"
  "policy-check-failures"
  "run-failures"
  "workspace-kpis-runs-count"
  "latest-change-at"
  "operations"
  "execution-mode"
  "vcs-repo"
  "vcs-repo-identifier"
  "description"
  "file-triggers-enabled"
  "assessments-enabled"
  "last-assessment-result-at"
  "source"
  "source-name"
  "source-url"
)

for KEY in "${!ENDPOINTS[@]}"; do
  NAME="${PREFIX[$KEY]}"

  echo ::debug::fetch ${NAME} ${KEY}

  JSON=$(api ${ENDPOINTS[$KEY]})
  echo ${NAME}_json="${JSON}" >> ${GITHUB_OUTPUT}

  # populate props
  VARNAME="${KEY}_PROPS"
  declare -n PROPS_ARRAY=${VARNAME}
  for PROP in "${PROPS_ARRAY[@]}"; do
    echo ${NAME}_${PROP//-/_}="$(echo "${JSON}" | jq -r .[\"${PROP}\"])" >> ${GITHUB_OUTPUT}
  done
done
