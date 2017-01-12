#!/bin/bash

BRANCH=$1
SERVER=`cat id`


if [[ -z $1 ]]; then
echo -e '\e[31myou must provide branch version: example:  "4.150.0"\e[0m'
fi

if [[ $SERVER == '' ]]; then
echo -e '\e[31myou must provide server: example: "agp-tn, uhc-tn, uhcc, national, de-uhc, ia-agp"\e[0m'
fi


if [[ $BRANCH != "" ]]; then
./single-deploy.sh $SERVER $BRANCH deploy && ./single-deploy.sh $SERVER $BRANCH intake && ./single-deploy.sh $SERVER $BRANCH process && ./single-deploy.sh $SERVER $BRANCH utils && ./single-deploy.sh $SERVER $BRANCH report && echo -e '\e[44mdeployed to ALL servers\e[0m'
echo -e '\e[44mAttempting to add instance back to load balancer\e[0m' && ./single-deploy.sh $SERVER $BRANCH deploy reinstate
fi
