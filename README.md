# hs-deploy
Deploy scripts for HealthStar servers

*Install*
- On the root of the bastion server you must add `deploy.sh` and `single-deploy.sh`<br>
- On the deploy web server you must add `create-image.sh` and run aws configure. This file is not needed any other server that doesnt use autoscaling. <br>
- On bastion server create a file named `id` put the server tag in there (ia-agp)<br>
- Edit the `create-image.sh` file to change the elb name to the correct elb<br>
- You will need to change permissions on the directory to make sure user `ubuntu` can access it.<br>
-- `sudo chown -R ubuntu:ubuntu .aws`<br>
- Then run `aws configure`<br>
-- `sudo chown -R ubuntu:ubuntu /var/tmp/aws-mon`<br>
```
*AWS CONFIG OPTIONS*
AKIAIXWP7YUNFIYK3RCQ<br>
gkIbVXwcUY6YTjrkM5XA/OGMHsbTLgK9FrCCsyxU<br>
us-east-1<br>
text<br>
```

*DEPLOY*
To deploy to all servers use the following:
- `./deploy.sh <branch version>`

To deploy to single servers use: 
- `./single-deploy.sh agp-tn 4.150.0 intake`

Deploy Servers will automatically create an image based off server and branch version. You'll still need to manually add the new AMI to the launch config and do the autoscaling for now. 

*YOU CANNOT CLONE THIS REPO TO THE SERVER ||| YOU MUST MANUALLY CREATE THE FILES*
