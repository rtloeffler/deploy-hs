#!/bin/bash
INSTANCE_ID=`cat /var/tmp/aws-mon/instance-id`
NAME=$1

if [[ $INSTANCE_ID != "" ]]; then
      sudo aws elb deregister-instances-from-load-balancer --load-balancer-name national-web --instances $INSTANCE_ID && echo -e '\e[44mREMOVED FROM ELB  SUCCESSFULLY\e[0m'
      sudo aws ec2 create-image --instance-id $INSTANCE_ID --name "$NAME" --region us-east-1 && echo -e '\e[44mIMAGE CREATED SUCCESSFULLY\e[0m'
      else
        echo -e '\e[31mIMAGE FAILED\e[0m'
fi
