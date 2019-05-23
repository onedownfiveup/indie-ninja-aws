.PHONY: deploy

export DATABSE_PASSWORD ?= $(aws secretsmanager get-random-password \
--password-length 50 --exclude-characters "/'\"@,")

create-ecr-repo:
	aws cloudformation deploy --template-file ecr.yaml --stack-name indie-ninja-api-ecr

create-kms:
	aws cloudformation deploy --template-file kms.yaml --stack-name indie-ninja-api-kms\
		--parameter-overrides $(cat dev.json | jq -r '.Parameters|to_entries[]|.key+"="+.value')

deploy/%:
	aws cloudformation deploy --template-file indie-ninja-api-stack.yaml --stack-name indie-ninja-api-$* \
    --parameter-overrides $$(cat $*.json | jq -r '.Parameters|to_entries[]|.key+"="+.value') \
    --capabilities CAPABILITY_NAMED_IAM

upload-stacks:
	for file in `ls  *.yaml`; do aws s3 cp --acl public-read $$file s3://indie-ninja-cloudformation-templates/; done
