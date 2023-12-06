EKS AMP Agentless Quickstart
===

Purpose of this repo is to provide you a handy script that helps you quickly get start to the [EKS Managed AMP Collector feature](https://aws.amazon.com/about-aws/whats-new/2023/11/amazon-managed-service-prometheus-agentless-collector-metrics-eks/).

As of today(2023-12-06) to create this repo, it is just a temporary workaround to simplify the manual process as mentioned in the [doc](https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-collector-how-to.html). Later on once AWS CloudFormation or Terraform start to support this new feature, I believe the process would be much easier.

## Prequisite
1. An EKS cluster
2. An AMP workspace
3. You have access to your EKS cluster with CLIs (including aws-cli, eksctl)

## Getting started
Edit the `setup.sh`, modify the top 3 environment variables, and run the commands below and all setup.