#Python code implemented as a Lambda funtion to start an ec2 instance, invoked by a cloudwatch event 
import boto3
def lambda_handler(event, context):
    id=i-0ee74379bc92c36e2
    ec2=boto3.client('ec2')
    response=ec2.start_instances(
        InstanceIds=id)

#Python code implemented as a Lambda funtion to stop an ec2 instance, invoked by a cloudwatch event 
import boto3
def lambda_handler(event, context):
    id=i-0ee74379bc92c36e2
    ec2=boto3.client('ec2')
    response=ec2.stop_instances(
        InstanceIds=id)

#Python code implremented as a Lambda function to reset the start and stop cloudwatch enemts to their defaults rules
#Invoked by a cloudwatch event at midinght on weekdays
import boto3
def lambda_handler(event, context):
    client=boto3.client('events')
    response = client.put_rule(
        Name='Umang-scheduler-start',
        ScheduleExpression='cron(0 9 ? * MON-FRI *)',
        State='ENABLED',
        Description='Start ec2 instance on weekdays at 9 am',
    )
    response1 = client.put_rule(
        Name='Umang-scheduler-stops',
        ScheduleExpression='cron(0 18 ? * MON-FRI *)',
        State='ENABLED',
        Description='Stops ec2 instance on weekdays at 6 pm',
    )

# Present start time is 9 am and stop time is 6 pm
import boto3
import datetime
def lambda_handler(event, context):
    ec2=boto3.client('ec2')
    id='i-0cc3fa01feb71a4dd'
    now=datetime.datetime.now()
    start=[(int(x) for x in event['start'].split())]
    stop=[(int(x) for x in event['stop'].split())]
    # case 1
    if 9<now.hour<start[0]: 
        response=ec2.stop_instances(
        InstanceIds=id)
    if start[0]<now.hour<9:
        response=ec2.start_instances(
        InstanceIds=id)
    if start[0]<9<now.hour:
        response=ec2.start_instances(
        InstanceIds=id)
    if 18<now.hour<stop[0]:
        response=ec2.start_instances(
        InstanceIds=id)
    if stop[0]<now.hour<18:
        response=ec2.stop_instances(
        InstanceIds=id)
        
         
    client1=boto3.client('events')
    response = client1.put_rule(
        Name='Umang-scheduler-start',
        ScheduleExpression='cron(0 %s ? * MON-FRI *)' %(start[0]),
        State='ENABLED',
        Description='Start ec2 instance on weekdays at 9 am',
    )
    response1 = client1.put_rule(
        Name='Umang-scheduler-stops',
        ScheduleExpression='cron(0 %s ? * MON-FRI *)' %(stop[0]),
        State='ENABLED',
        Description='Stops ec2 instance on weekdays at 6 pm',
    )



#Below is the script which is to be run if the user wishes to schedule the instances manually

#!/bin/bash
echo Enter the Start time for today in the format HH MM
read start
echo Enter the Stop Time for today in the format HH MM
read stop
aws lambda invoke --function-name 'Umang_Scheduler' --invocation-type 'Event' --payload '{"start":"$start","stop":"$stop"}' outputfile.txt 
