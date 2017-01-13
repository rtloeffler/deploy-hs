#!/bin/bash
BRANCH=$1
SERVER=`cat id`

dialog --title "Migrations" \
--backtitle "Dynamic Vision Deploy" \
--yesno "Do you have a Manual Migration?" 7 60

# For migrations only
# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
case $response in
   0) migration=$? ;;

   1) echo "Starting Deploy Process - No Migrations" && migrationno='no-migration';;

   255) echo "[ESC] key pressed.";;

esac

if [[ $migration == 0 ]]; then
	# remove or create tmp file
	tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/manmig$$
	trap "rm -f $tempfile" 0 1 2 5 15
	#dialog box for manual migraiton

	dialog --title "Migrations" --clear \
	--backtitle "Dynamic Vision Deploy" \
	--inputbox "Enter Manual Migration file name" 7 60 2> /tmp/manmig
	
	#grab the value of the last command
	retval=$?
	case $retval in
		0) echo "Got it, will run manual migration last";;
		1) echo "Canceling Migration";;
		255) echo "[ESC] key pressed.";;
esac
fi

checkmanmig=`cat /tmp/manmig`

if [[ $checkmanmig == '' && $migration == 0 ]]; then
	echo -e '\e[31myou left the man mig blank\e[0m'
	exit
fi



# DEPLOY CODE STARTING NOW

if [[ $SERVER == '' ]]; then
echo -e '\e[31myou must provide server: example: "agp-tn, uhc-tn, uhcc, national, de-uhc, ia-agp-- check the file "id"\e[0m'
fi

if [[ $BRANCH != "" ]]; then
./single-deploy.sh $SERVER $BRANCH deploy && ./single-deploy.sh $SERVER $BRANCH intake && ./single-deploy.sh $SERVER $BRANCH process && ./single-deploy.sh $SERVER $BRANCH utils && ./single-deploy.sh $SERVER $BRANCH report && echo -e '\e[44mdeployed to ALL servers\e[0m'
echo -e '\e[44mAttempting to add instance back to load balancer\e[0m' && ./single-deploy.sh $SERVER $BRANCH deploy reinstate
fi

# MANUAL MIGRATION
if [[ $BRANCH != "" && $migration == 0 ]]; then
./single-deploy.sh $SERVER $BRANCH utils noreinstate $checkmanmig
fi

# FINAL COMPLETION
if [[ $? == 0 ]]; then
	echo -e '\e[44mEVERYTHING IS ALL DONE\e[0m'
fi
