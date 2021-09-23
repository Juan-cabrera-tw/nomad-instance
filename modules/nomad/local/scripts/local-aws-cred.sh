cd modules/nomad/local/scripts
vault read aws/creds/my-role >> keys
awk '{ print "\""$0"\""}' keys >> keys.credentials
rm keys
egrep 'access_key|secret_key' keys.credentials >> aws.credentials
perl -i -pe 's/"access_key/AWS_ACCESS_KEY_ID="/g' aws.credentials
perl -i -pe 's/"secret_key/AWS_SECRET_ACCESS_KEY="/g' aws.credentials 
perl -i -pe 's/ //g' aws.credentials 
echo "AWS_DEFAULT_REGION=us-east-2" >> aws.credentials