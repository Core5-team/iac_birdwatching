## This repository contains a collection of Terraform modules used to deploy the core infrastructure for a Birdwatching application:

## Load Balancer module (lb)

## Web application module (web)

## Database module (db)

## S3 images bucket module (images)

Each module is isolated and reusable, but also designed to integrate with others when needed.

| Variable          | Type   |                Description                 |
| ----------------- | ------ | :----------------------------------------: |
| vpc_id            | string | ID of VPC where infrastructure is deployed |
| igw_id            | string |            Internet Gateway ID             |
| availability_zone | string |   Availability zone for EC2 and subnets    |
| common_tags       | map    |      Common tagging for all resources      |
| env               | string | Environment name (e.g., stage_01, prod_01) |
