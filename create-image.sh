#!/bin/bash
INSTANCE_ID=`cat /var/tmp/aws-mon/instance-id`
NAME=$1
REINSTATE=$2


if [[ $INSTANCE_ID != "" ]] && [[  $REINSTATE = "" ]]; then
      sudo aws elb deregister-instances-from-load-balancer --load-balancer-name ia-agp-web --instances $INSTANCE_ID && echo -e '\e[44mREMOVED FROM ELB  SUCCESSFULLY\e[0m'
      sudo aws ec2 create-image --instance-id $INSTANCE_ID --name "$NAME" --region us-east-1 && echo -e '\e[44mIMAGE CREATED SUCCESSFULLY\e[0m'
elif [[ $REINSTATE != "" ]];
then
	echo 'about to add instance back to load balancer'
      else
        echo -e '\e[31mIMAGE FAILED\e[0m'
fi

if [[ $REINSTATE == "reinstate" ]]; then
	sudo aws elb register-instances-with-load-balancer --load-balancer-name ia-agp-web --instances $INSTANCE_ID && echo -e '\e[44mREMOVED FROM ELB  SUCCESSFULLY\e[0m'
else
	echo -e '\e[31mFAILED TO PUT DEPLOY SERVER BACK INTO LOAD BALANCER - please add it back manually using the UI'
fi
