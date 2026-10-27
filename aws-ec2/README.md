# Ephemeral EC2 GitHub Runner

This pipeline provisions a disposable EC2 self-hosted runner before the build job, stores runner logs in S3, and terminates the instance after all steps finish or fail.

## AWS Prerequisites

1. Create an EC2 instance profile named `makrsoft-github-runner-instance-profile`.
2. Attach `ec2-instance-role-policy.json` to the instance role. Replace `__LOG_BUCKET_ARN__` with the S3 bucket ARN.
3. Create a private runner subnet with outbound access through a NAT gateway or VPC endpoints.
4. Create a launch template named, for example, `makrsoft-actions-runner` using `launch-template-example.json`.
5. Create a GitHub OIDC role in AWS and attach `provisioner-policy.json`, replacing wildcard limits with the account-specific resources where possible.
6. Create the runner log bucket and grant the EC2 instance role write access to `github-runs/*`.

## GitHub Configuration

Add repository variables:

```text
AWS_REGION=us-east-1
AWS_LAUNCH_TEMPLATE=makrsoft-actions-runner
RUNNER_LOG_BUCKET=your-runner-log-bucket
```

Add repository secrets:

```text
AWS_GITHUB_OIDC_ROLE_ARN=arn:aws:iam::<account-id>:role/<github-actions-role>
GH_ORG_PAT=<organization runner registration token capable PAT>
```

The PAT is used only in the provisioning job. Prefer a GitHub App implementation for production because registration and removal tokens should be short-lived.

## Organization Runner Access

Enable organization runners for this repository under:

```text
Organization settings > Actions > Runners
```

The workflow requests the labels:

```text
self-hosted, linux, x64, docker-agent
```

The EC2 bootstrap configures these labels with an organization-level runner registration.

## Failure Safety

The cleanup job always terminates the instance and deletes the SSM registration parameter. Add an EventBridge scheduled fallback that terminates instances tagged by GitHub run ID after a maximum lifetime, because a cancelled workflow or AWS outage may interrupt normal cleanup.

## Create the Launch Template

After replacing values in `launch-template-example.json`:

```bash
aws ec2 create-launch-template \
  --launch-template-name makrsoft-actions-runner \
  --version-description "Ephemeral GitHub Actions runner" \
  --launch-template-data file://aws-ec2/launch-template-example.json
```

Run the workflow from `.github/workflows/ec2.yml`.
