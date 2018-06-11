#lambda function that gets invoked upon every object creation

import boto3
def lambda_handler(event, context):
    s3=boto3.resource('s3')
    key_path = event['Records'][0]['s3']['object']['key']
    copy_source = {
      'Bucket': 'umang01',
      'Key': key_path
      }
    bucket = s3.Bucket('umang02')
    bucket.copy(copy_source, key_path)
