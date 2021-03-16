#!/bin/sh

set -e

profile="$1"
region="$2"
instance_id="$3"
password="$(openssl rand -hex 32)"
parameter_name="$4"

echo "[INFO]: Updating RDS database password"
aws --region=$region --profile=$profile rds modify-db-instance --db-instance-identifier $instance_id --master-user-password $password
echo "[SUCCESS]: Updating RDS database password"

echo "[INFO]: Sending password to parameter storage"
aws --region=$region --profile=$profile ssm put-parameter --name $parameter_name --type "SecureString" --value $password --overwrite
echo "[SUCCESS]: Sending password to parameter storage"
