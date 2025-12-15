# Birdwatching Infrastructure Modules

This repository contains reusable Terraform modules that define core infrastructure components for the Birdwatching platform.
It is designed to be consumed by a **Terragrunt-based** orchestration repository, but each module can also be used independently.

All components are fully parameterized via variables, making the setup environment-agnostic and suitable for reuse across different projects or stages.

## Repository Structure

The repository follows a modular layout, where each directory represents a standalone Terraform module:

- ```modules/db``` – database infrastructure
- ```modules/lb``` – load balancer and related networking
- ```modules/web``` – web/application layer resources
- ```modules/s3_images``` – S3 bucket for image storage

Root-level Terraform files (```main.tf```, ```providers.tf```, ```variables.tf```, ```outputs.tf```) expose these modules for composition when needed.

## Design Principles

- Modular – each component is isolated and can be enabled or disabled independently
- Reusable – no hardcoded values; everything is configurable via variables
- Terragrunt-friendly – intended to be wrapped and instantiated by Terragrunt
- Environment-agnostic – supports multiple environments (dev, stage, prod)

## Usage Model

This repository is **not meant to be applied directly** in most cases.

#### Typical flow:
1. A Terragrunt repository defines environments and state configuration
2. Terragrunt calls modules from this repository
3. Environment-specific values are injected via variables

Terragrunt orchestration repository: https://github.com/Core5-team/iac-terragrunt

Direct ```terraform apply``` is possible, but not the primary use case.

### Running Without Terragrunt

For local testing or standalone usage, this repository can be applied directly with Terraform.

From the repository root:

```terraform init```
```terraform plan```
```terraform apply```

All required values must be provided via a .tfvars file or default values in variables.tf.

Remote state configuration, environment separation and variable injection are expected to be handled externally when not using Terragrunt.

## Common Inputs

Most modules share a common set of inputs to ensure consistency across environments.

| Variable          | Type   |                Description                 |
| ----------------- | ------ | :----------------------------------------: |
| vpc_id            | string | ID of VPC where infrastructure is deployed |
| igw_id            | string |            Internet Gateway ID             |
| availability_zone | string |   Availability zone for EC2 and subnets    |
| common_tags       | map    |      Common tagging for all resources      |
| env               | string | Environment name (e.g. stage_01, prod_01)  |
