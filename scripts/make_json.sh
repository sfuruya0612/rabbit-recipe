#! /bin/bash
set -ex

AWS_ACCOUNTID=$1
AWS_REGION=$2
PROJECT_NAME=$3
ENV=$4
ROLE=$5

container_name=${ROLE}
ecr_uri=${AWS_ACCOUNTID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-${ENV}/${ROLE}

# cat << EOS | jq > concat.txt
cat << EOS > imagedefinitions_${ROLE}.json
[
    {
        "name": "${container_name}",
        "imageUri": "${ecr_uri}"
    }
]
EOS
