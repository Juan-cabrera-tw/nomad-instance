cd modules/nomad/local/scripts

if ! [ -z "${AWS_ECR_PULL_ACCESSS_KEY}" ] && ! [ -z "${AWS_ECR_PULL_SECRET_KEY}" ]; then
    echo "pipeline execution"
    echo "AWS_ACCESS_KEY_ID=\"${AWS_ECR_PULL_ACCESSS_KEY}\"" >> aws.credentials
    echo "AWS_SECRET_ACCESS_KEY=\"${AWS_ECR_PULL_SECRET_KEY}\"" >> aws.credentials
    echo "AWS_DEFAULT_REGION=us-east-2" >> aws.credentials
else
    echo "local execution"
    vault read aws/creds/my-role >> keys
    awk '{ print "\""$0"\""}' keys >> keys.credentials
    rm keys
    egrep 'access_key|secret_key' keys.credentials >> aws.credentials
    rm keys.credentials 
    perl -i -pe 's/"access_key/AWS_ACCESS_KEY_ID="/g' aws.credentials
    perl -i -pe 's/"secret_key/AWS_SECRET_ACCESS_KEY="/g' aws.credentials 
    perl -i -pe 's/ //g' aws.credentials 
    echo "AWS_DEFAULT_REGION=us-east-2" >> aws.credentials 
fi

