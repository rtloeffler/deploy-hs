# hs-deploy
Deploy scripts for HealthStar servers

*Install*
On the root of the bastion server you must add `deploy.sh` and `single-deploy.sh`
On the deploy web server you must add `create-image.sh` and run aws configure. 

*AWS CONFIG OPTIONS*

AKIAIXWP7YUNFIYK3RCQ
gkIbVXwcUY6YTjrkM5XA/OGMHsbTLgK9FrCCsyxU
us-east-1
text

You will need to change permissions on the directory to make sure user `ubuntu` can access it. 
`sudo chown -R /var/tmp/aws-mon`

*DEPLOY*
To deploy to all servers use the following:
`./deploy.sh <branch version>`

To deploy to single servers use: 
`./single-deploy.sh agp-tn 4.150.0 intake`

Deploy Servers will automatically create an image based off server and branch version. You'll still need to manually add the new AMI to the launch config and do the autoscaling for now. 
