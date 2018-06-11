#!/bin/bash
id=i-0cc3fa01feb71a4dd
status=$(aws ec2 describe-instances --instance-ids $id --query Reservations[].Instances[].State.Name --output text)
echo  Your Instance is currently $status
echo  Enter 1 to change the present state of the instance or enter 2 to schedule
read ch
echo $ch
if [  "$ch" == "1" ] && [ "$status" == "running" ];
then 
    aws ec2 stop-instances --instance-ids $id
    echo Instance Stopped
fi
if [ "$ch" == "1" ] && [ "$status" == "stopped" ];
then
    aws ec2 start-instances --instance-ids $id
    echo Instance Started
fi
  

if [ "$ch" -eq "2" ]
then
  read -p "Enter the start time of the instance in HH" istart
  read -p "Enter the stop time of the instance in HH" istop
  aws events put-rule --name "start-at-9am-mon-fri" --schedule-expression "cron(0 $istart ? * MON-FRI *)"
  aws events put-rule --name "stop-at-6pm-mon-fri" --schedule-expression "cron(0 $istop ? * MON-FRI *)"
#else
#  echo Wrong choice
fi
  