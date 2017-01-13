# hs-deploy
Deploy scripts for HealthStar servers

*Install*
- On the root of the bastion server you must add `deploy.sh` and `single-deploy.sh`<br>
- On the deploy web server you must add `create-image.sh` and run aws configure. This file is not needed any other server that doesnt use autoscaling. <br>
- On bastion server create a file named `id` put the server tag in there (ia-agp)<br>
- On Deploy (web server) create file called `elb`, in that file add the elb name for that instance<br>
- You will need to change permissions on the directory to make sure user `ubuntu` can access it.<br>
-- `sudo chown -R ubuntu:ubuntu .aws`<br>
- Then run `aws configure`<br>
-- `sudo chown -R ubuntu:ubuntu /var/tmp/aws-mon`<br>
```
*AWS CONFIG OPTIONS*
AKIAIXWP7YUNFIYK3RCQ
gkIbVXwcUY6YTjrkM5XA/OGMHsbTLgK9FrCCsyxU
us-east-1
text
```

*DEPLOY*
To deploy to all servers use the following:
- `./deploy.sh <branch version>`
- example: `./deploy.sh 4.150.0`
- You'll still need to create the launch config and add the instance back to the elb
- it'll prompt for manual migrations
- Regular migrations will run automatically 

To deploy to single servers use: 
- `./single-deploy.sh agp-tn 4.150.0 intake`


Deploy Servers will automatically create an image based off server and branch version. You'll still need to manually add the new AMI to the launch config and do the autoscaling for now. 

*YOU CANNOT CLONE THIS REPO TO THE SERVER ||| YOU MUST MANUALLY CREATE THE FILES UNLESS PARENT DIRECTORY IS EMPTY*
