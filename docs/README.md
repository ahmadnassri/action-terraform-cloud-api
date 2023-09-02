## Why

## Usage

```yaml
jobs:
  job:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      # read workspace information from .terraform/terraform.tfstate file
      - id: terraform
        uses: ahmadnassri/action-terraform-cloud-api@v1
        with:
          token: ${{ secrets.TERRAFORM_TOKEN }}

      # specify organization and workspace
      - id: terraform
        uses: ahmadnassri/action-terraform-cloud-api@v1
        with:
          token: ${{ secrets.TERRAFORM_TOKEN }}
          organization: foobar
          workspace: my-project

      # check if workspace is locked before attempting a run
      - if: steps.terraform.outputs.workspace_locked == 'true'
        run: echo "workspace is locked!"

      # fetch information
      - run: |
        echo ${{ steps.terraform.outputs.workspace_locked }}
        echo ${{ steps.terraform.outputs.workspace_run_failures }}
        echo ${{ steps.terraform.outputs.workspace_terraform_version }}
        echo ${{ steps.terraform.outputs.organization_is_in_degraded_mode }}
        echo ${{ steps.terraform.outputs.organization_managed_resource_count }}

      # advanced usage example:
      - run: |
        echo ${{ steps.terraform.outputs.organization_json }}" | jq '.external-id, .name, .created-at'
```

## Inputs

| Input          | Required | Default                        | Description                   |
| -------------- | -------- | ------------------------------ | ----------------------------- |
| `token`        | ✔️       | `N/A`                          | the Terraform Cloud API Token |
| `state`        | ❌       | `.terraform/terraform.tfstate` | Path to terraform state file  |
| `organization` | ❌       | `github.repository_owner`      | Terraform Cloud Org name      |
| `workspace`    | ❌       | `-`                            | Workspace name                |

> **NOTE**  
> if `organization` & `workspace` are not provided, the action will attempt to read the info from the terraform state file

## Outputs

| Property                                         | Description                                    |
| ------------------------------------------------ | ---------------------------------------------- |
| **`workspace_json`**                             | `{ ... }` full JSON object of the workspace    |
| **`workspace_allow_destroy_plan`**               | `true`                                         |
| **`workspace_auto_apply`**                       | `false`                                        |
| **`workspace_auto_destroy_at`**                  | `null`                                         |
| **`workspace_auto_destroy_status`**              | `null`                                         |
| **`workspace_environment`**                      | `default`                                      |
| **`workspace_locked`**                           | `false`                                        |
| **`workspace_name`**                             | `github`                                       |
| **`workspace_queue_all_runs`**                   | `false`                                        |
| **`workspace_speculative_enabled`**              | `true`                                         |
| **`workspace_structured_run_output_enabled`**    | `false`                                        |
| **`workspace_terraform_version`**                | `1.3.6`                                        |
| **`workspace_working_directory`**                | ` `                                            |
| **`workspace_global_remote_state`**              | `false`                                        |
| **`workspace_updated_at`**                       | `2023-09-01T18:40:06.586Z`                     |
| **`workspace_resource_count`**                   | `428`                                          |
| **`workspace_apply_duration_average`**           | `null`                                         |
| **`workspace_plan_duration_average`**            | `null`                                         |
| **`workspace_policy_check_failures`**            | `null`                                         |
| **`workspace_run_failures`**                     | `null`                                         |
| **`workspace_workspace_kpis_runs_count`**        | `null`                                         |
| **`workspace_latest_change_at`**                 | `2023-09-01T18:40:06.108Z`                     |
| **`workspace_operations`**                       | `false`                                        |
| **`workspace_execution_mode`**                   | `local`                                        |
| **`workspace_vcs_repo`**                         | `null`                                         |
| **`workspace_vcs_repo_identifier`**              | `null`                                         |
| **`workspace_description`**                      | `null`                                         |
| **`workspace_file_triggers_enabled`**            | `false`                                        |
| **`workspace_assessments_enabled`**              | `false`                                        |
| **`workspace_last_assessment_result_at`**        | `null`                                         |
| **`workspace_source`**                           | `tfe-ui`                                       |
| **`workspace_source_name`**                      | `null`                                         |
| **`workspace_source_url`**                       | `null`                                         |
| **`organization_json`**                          | `{ ... }` full JSON object of the organization |
| **`organization_external_id`**                   | `org-va2BrNsb8Q3ap2CP`                         |
| **`organization_created_at`**                    | `2020-07-02T15:56:55.593Z`                     |
| **`organization_email`**                         | `foo@bar.com`                                  |
| **`organization_session_timeout`**               | `null`                                         |
| **`organization_session_remember`**              | `null`                                         |
| **`organization_collaborator_auth_policy`**      | `password`                                     |
| **`organization_plan_expired`**                  | `false`                                        |
| **`organization_plan_expires_at`**               | `null`                                         |
| **`organization_plan_is_trial`**                 | `false`                                        |
| **`organization_plan_is_enterprise`**            | `false`                                        |
| **`organization_plan_identifier`**               | `free_standard`                                |
| **`organization_cost_estimation_enabled`**       | `false`                                        |
| **`organization_managed_resource_count`**        | `690`                                          |
| **`organization_allow_force_delete_workspaces`** | `true`                                         |
| **`organization_assessments_enforced`**          | `false`                                        |
| **`organization_is_in_degraded_mode`**           | `true`                                         |
| **`organization_name`**                          | `foobar`                                       |
| **`organization_saml_enabled`**                  | `false`                                        |
| **`organization_fair_run_queuing_enabled`**      | `false`                                        |
| **`organization_owners_team_saml_role_id`**      | `null`                                         |
| **`organization_two_factor_conformant`**         | `true`                                         |
