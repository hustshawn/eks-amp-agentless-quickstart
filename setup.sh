# Reference: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-collector-how-to.html

## Only need to update below 3 environment variables to get start
export CLUSTER_NAME=your-eks-cluster-name # Modify as your existing EKS cluster
export AWS_DEFAUL_REGION=region-ocde  # modify the region code
export workspaceArn=arn:aws:aps:region-code:your-aws-account:workspace/ws-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx # update it to your existing AMP workspace


export clusterArn=$(aws eks describe-cluster --name ${CLUSTER_NAME} --output json | jq '.cluster.arn')
export subnetIds=$(aws eks describe-cluster --name ${CLUSTER_NAME} --output json | jq '.cluster.resourcesVpcConfig.subnetIds')
export securityGroupIds=$(aws eks describe-cluster --name ${CLUSTER_NAME} --output json | jq '.cluster.resourcesVpcConfig.securityGroupIds')
aws amp create-scraper \
  --source eksConfiguration="{clusterArn=${clusterArn}, securityGroupIds=${securityGroupIds},subnetIds=${subnetIds}}" \
  --scrape-configuration configurationBlob=$(cat config.yaml | base64) \
  --destination ampConfiguration="{workspaceArn=${workspaceArn}}"


## Configure at EKS cluster
kubectl apply -f clusterrole-binding.yaml
export SCRAPER_ID=$(aws amp list-scrapers | jq -r '.scrapers[].scraperId')
aws amp describe-scraper --scraper-id ${SCRAPER_ID}
export AMP_AGENT_ROLE_ARN=$(aws amp describe-scraper --scraper-id ${SCRAPER_ID} | jq -r '.scraper.roleArn' | cut -d '/' -f1,4)
eksctl create iamidentitymapping --cluster ${CLUSTER_NAME} --region ${AWS_DEFAULT_REGION} --arn ${AMP_AGENT_ROLE_ARN} --username aps-collector-user


## Clean up
eksctl delete iamidentitymapping --cluster ${CLUSTER_NAME} --arn $AMP_AGENT_ROLE_ARN