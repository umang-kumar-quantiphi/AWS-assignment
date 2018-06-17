#!/bin/bash

#Launching first instance
aws ec2 run-instances --image-id ami-14c5486b --instance-type t2.micro --key-name PE_Umang_1 --iam-instance-profile Name=PE_trainee_Admin_role --user-data  '#!/bin/bash
yum update -y  
sudo -u ec2-user ssh-keygen -t rsa -b 2048 -f /home/ec2-user/.ssh/id_rsa -q -N ""
aws s3 cp /home/ec2-user/.ssh/id_rsa.pub s3://umang01/id_rsa.pub' --region us-east-1 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=FirstInstance}]'


#exists=$(aws s3 ls s3://umang01//id_rsa.pub)
#echo Uploading FIle....
#while [ -z "$exists" ]
#do
#sleep 5
#exists=$(aws s3 ls s3://umang01//id_rsa.pub)
#done
#echo Upload complete!

#Launching second instance
aws ec2 run-instances --image-id ami-14c5486b --instance-type t2.micro --key-name PE_Umang_1 --iam-instance-profile Name=PE_trainee_Admin_role --user-data  '#!/bin/bash
yum update -y
aws s3 cp s3://umang01/id_rsa.pub /home/ec2-user/.ssh/
chmod 700 /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/id_rsa.pub
chmod 600 /home/ec2-user/.ssh/authorized_keys	
cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys' --region us-east-1 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=SecondInstance}]'