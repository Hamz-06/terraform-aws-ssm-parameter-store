# terraform-aws-ssm-parameter-store

Terraform module for creating a set of SSM Parameter Store entries for an
application/environment, backed by [`terraform-aws-modules/ssm-parameter/aws`](https://registry.terraform.io/modules/terraform-aws-modules/ssm-parameter/aws/latest).

## Usage

```hcl
module "ssm_parameter_store" {
  source = "git::https://github.com/<org>/terraform-aws-ssm-parameter-store.git?ref=v2.1.2"

  environment      = "prod"
  application_name = "my-app"

  ssm_parameters = {
    db_password = {
      value     = "super-secret"
      overwrite = true
      version   = 1
    }
  }

  tags = {
    Team = "platform"
  }
}
```

## Inputs

| Name               | Description                                              | Type     | Default |
| ------------------ | ---------------------------------------------------------| -------- | ------- |
| `environment`       | Deployment environment (`dev` or `prod`)                 | `string` | n/a     |
| `application_name`  | Name of the application being deployed                   | `string` | n/a     |
| `ssm_parameters`    | Map of SSM parameter keys to their configuration          | `map(object)` | `{}` |
| `tags`              | Tags to apply to all SSM parameters                       | `map(string)` | `{}` |

## Outputs

| Name                 | Description                                                    |
| -------------------- | ---------------------------------------------------------------|
| `parameter_path_arn` | ARN wildcard for all SSM parameters under the service/env path |
| `parameter_values`   | Values of the SSM parameters managed by this module            |

## Versioning

This repo uses [changesets](https://github.com/changesets/changesets) to track
version bumps and generate a changelog, even though it's a Terraform module
(not an npm package). Releases are still cut as git tags, which is what
consumers reference in their `source`/`ref`.

1. After making a change, run:
   ```sh
   npx changeset
   ```
   Select the bump type (`patch`/`minor`/`major`) and write a short summary.
   This creates a markdown file in `.changeset/` — commit it with your PR.

2. When ready to release, run:
   ```sh
   npx changeset version
   ```
   This consumes the pending changeset files, bumps the `version` in
   `package.json`, and updates `CHANGELOG.md`.

3. Commit the version bump, then tag and push it so consumers can reference it:
   ```sh
   git tag v$(node -p "require('./package.json').version")
   git push origin main --tags
   ```
