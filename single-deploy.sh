#!/bin/bash

TARGET_ENV=$3
TARGET_HOST=""
SERVER_ENV=$1
SERVER=""
BRANCH=$2
NAME=$SERVER_ENV-$BRANCH
REINSTATE=$4
manmig=$5

#check for branch name

if [[ -z $1 ]];
then
  echo -e '\e[31myou must provide a SERVER => agp-tn, uhc-tn, uhcc, national, de-uhc, ia-agp\e[0m'
elif [[ $SERVER_ENV == "agp-tn" ]];
then
  SERVER='amerigroup'
elif [[ $SERVER_ENV == "uhc-tn" ]];
then
  SERVER='united'
elif [[ $SERVER_ENV == "uhcc" ]];
then
  SERVER='uhc-connections'
elif [[ $SERVER_ENV == "national" ]];
then
  SERVER='national'
elif [[ $SERVER_ENV == "de-uhc" ]];
then
  SERVER='uhc-delaware'
elif [[ $SERVER_ENV == "ia-agp" ]];
then
  SERVER='agp-iowa'  
fi

#check for branch version number

if [[ -z $2 ]]; then
echo -e '\e[31myou must provide a BRANCH Version => example: 4.150.0\e[0m'
fi

#check for server
if [[ -z $3 ]]; then
echo -e '\e[31myou must provide target environment -> deploy, intake, process, utils, or report\e[0m'
fi

# define real server host with instance

# National
if [[ $1 == 'national' && $TARGET_ENV == "utils" ]];
then
  TARGET_HOST='ip-10-4-6-151.ec2.internal'
elif [[ $1 == 'national' && $TARGET_ENV == "deploy" ]]; 
then
  TARGET_HOST='ip-10-4-7-158.ec2.internal'
# AGP TN
elif [[ $1 == 'agp-tn' && $TARGET_ENV == "deploy" ]];
then
  TARGET_HOST='ip-10-2-0-155.ec2.internal'
elif [[ $1 == 'agp-tn' && $TARGET_ENV == "intake" ]];
then
  TARGET_HOST='10.2.0.32'
elif [[ $1 == 'agp-tn' && $TARGET_ENV == "process" ]];
then
  TARGET_HOST='10.2.0.125'
elif [[ $1 == 'agp-tn' && $TARGET_ENV == "utils" ]];
then
  TARGET_HOST='10.2.0.234'
elif [[ $1 == 'agp-tn' && $TARGET_ENV == "report" ]];
then
  TARGET_HOST='10.2.0.126'
# UHC TN
elif [[ $1 == 'uhc-tn' && $TARGET_ENV == "deploy" ]];
then
  TARGET_HOST='ip-10-3-0-133.ec2.internal'
elif [[ $1 == 'uhc-tn' && $TARGET_ENV == "intake" ]];
then
  TARGET_HOST='ip-10-3-0-244.ec2.internal'
elif [[ $1 == 'uhc-tn' && $TARGET_ENV == "process" ]];
then
  TARGET_HOST='ip-10-3-0-245.ec2.internal'
elif [[ $1 == 'uhc-tn' && $TARGET_ENV == "utils" ]];
then
  TARGET_HOST='10.3.0.202'
elif [[ $1 == 'uhc-tn' && $TARGET_ENV == "report" ]];
then
  TARGET_HOST='ip-10-3-0-243.ec2.internal'
# UHC C
elif [[ $1 == 'uhcc' && $TARGET_ENV == "deploy" ]];
then
  TARGET_HOST='10.4.2.153'
# DE UHC
elif [[ $1 == 'de-uhc' && $TARGET_ENV == "deploy" ]];
then
  TARGET_HOST='ip-10-5-10-84.ec2.internal'
elif [[ $1 == 'de-uhc' && $TARGET_ENV == "intake" ]];
then
  TARGET_HOST='ip-10-5-14-7.ec2.internal'
elif [[ $1 == 'de-uhc' && $TARGET_ENV == "process" ]];
then
  TARGET_HOST='ip-10-5-18-85.ec2.internal'
elif [[ $1 == 'de-uhc' && $TARGET_ENV == "utils" ]];
then
  TARGET_HOST='ip-10-5-20-80.ec2.internal'
elif [[ $1 == 'de-uhc' && $TARGET_ENV == "report" ]];
then
  TARGET_HOST='ip-10-5-22-178.ec2.internal'
# IA AGP
elif [[ $1 == 'ia-agp' && $TARGET_ENV == "deploy" ]];
then
  TARGET_HOST='ip-10-6-10-192.ec2.internal'
elif [[ $1 == 'ia-agp' && $TARGET_ENV == "intake" ]];
then
  TARGET_HOST='ip-10-6-16-21.ec2.internal'
elif [[ $1 == 'ia-agp' && $TARGET_ENV == "process" ]];
then
  TARGET_HOST='ip-10-6-18-161.ec2.internal'
elif [[ $1 == 'ia-agp' && $TARGET_ENV == "utils" ]];
then
  TARGET_HOST='ip-10-6-20-30.ec2.internal'
elif [[ $1 == 'ia-agp' && $TARGET_ENV == "report" ]];
then
  TARGET_HOST='ip-10-6-22-100.ec2.internal'
fi


# Deploy code
if [[ $TARGET_HOST != "" ]] && [[ $SERVER != "" ]] && [[ $BRANCH != "" ]] && [[ $REINSTATE != "reinstate" ]]; then
  echo -e '\e[42mALL CHECKS PASSED STARTING DEPLOY...\e[0m'
  sleep 2
  echo -e '\e[42mConnecting to ' $TARGET_HOST $SERVER 
  echo -e '\e[0m'
fi
  # Run Manual Migraiton
  if [[ $manmig != '' ]];
    then
    ssh ubuntu@$TARGET_HOST -A "echo -e '\e[42mStarting Manual Migration\e[0m' && cd /var/www/visitverify/www/ && php index.php db upgrade_manual $manmig"
    echo -e '\e[42mMANUAL MIGRATION COMPLETED\e[0m'
  elif [[ $manmig == '' ]];
    then
    echo ''
  else 
    echo -e '\e[31mMANUAL MIGRAITON FAILED CHECK HISTORY\e[0m'
fi

  # RUN REGULAR DEPLOY PROCESS
  if [[ $REINSTATE != "reinstate" && $manmig == ''  ]]; 
    then
      ssh ubuntu@$TARGET_HOST -A "echo -e '\e[42mconnected to ' $TARGET_HOST && echo -e '\e[0m' && sleep 2 && cd /var/www/visitverify && git branch && sleep 2 && git fetch && echo -e '\e[42mDeploying to' $BRANCH $SERVER && echo -e '\e[0m' && sleep 2 && git checkout origin/instance/$SERVER-$BRANCH && echo -e '\e[42m' && git branch && echo -e '\e[0m' && sleep 2"
      echo -e '\e[44mdeployed' $BRANCH ' to' $SERVER_ENV $TARGET_ENV 'server....over and out\e[0m'
elif [[ $REINSTATE != "" ]];
then
    echo 'nothing to do here'
  else 
      echo -e '\e[31mDEPLOY FAILUR: CHECK HISTORY\e[0m'
fi

# Create Image and take out of load balancer
if [[ $TARGET_ENV == "deploy" ]] && [[ $REINSTATE != "reinstate" ]];
then
  ssh ubuntu@$TARGET_HOST -A "./create-image.sh $NAME"
  sleep 2
else
  echo -e 'no need to create image'
fi

# Re-register with load balancer
if [[ $REINSTATE == "reinstate" ]];
then
  for i in {1..5}; do ssh ubuntu@$TARGET_HOST -A "./create-image.sh $NAME reinstate" && break || echo 'connection timeout' sleep 15; done
fi
