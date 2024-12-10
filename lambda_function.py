import boto3
import json
import os
import pandas as pd
import numpy as np
import logging
from sqlalchemy import create_engine
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# RDS Connection Configuration
rds_endpoint = os.environ['RDS_ENDPOINT']
rds_port = os.environ['RDS_PORT']
rds_user = os.environ['RDS_USER']
rds_dbname = os.environ['RDS_DBNAME']

# Fetch RDS Password from Secrets Manager
secrets_manager = boto3.client('secretsmanager')
try:
    secret = secrets_manager.get_secret_value(SecretId='your-secret-id')
    rds_password = json.loads(secret['SecretString'])['password']
except ClientError as e:
    logger.error(f"Failed to fetch RDS password from Secrets Manager: {e}")
    raise

# Initialize AWS services clients
s3 = boto3.client('s3')
sqs = boto3.client('sqs')
sns = boto3.client('sns')

# Configuration from Environment Variables
sqs_queue_url = os.environ['SQS_QUEUE_URL']
sns_topic_arn = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    try:
        logger.info("Event: " + json.dumps(event))
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']

        # Check file type
        file_extension = key.split('.')[-1].lower()
        if file_extension not in ['csv', 'txt']:
            logger.info(f"Skipping file {key} as it's not a CSV or TXT file.")
            return {
                'statusCode': 200,
                'body': json.dumps('File type not supported.')
            }

        # Download the file
        file_path = f"/tmp/{key}"
        s3.download_file(bucket, key, file_path)

        # Read the file content
        try:
            with open(file_path, 'r') as file:
                content = file.read()
        except IOError as e:
            logger.error(f"Error reading file {key}: {e}")
            raise

        # Write to RDS
        engine = create_engine(f"mysql+pymysql://{rds_user}:{rds_password}@{rds_endpoint}:{rds_port}/{rds_dbname}")
        try:
            with engine.connect() as connection:
                connection.execute("INSERT INTO your_table (filename, content) VALUES (%s, %s)", (key, content))
            logger.info(f"Data from {key} inserted into RDS.")
        except Exception as e:
            logger.error(f"RDS insertion error for file {key}: {e}")
            raise

        # Send message to SQS
        try:
            sqs.send_message(
                QueueUrl=sqs_queue_url,
                MessageBody=f"File {key} processed"
            )
            logger.info(f"Message sent to SQS for file {key}")
        except ClientError as e:
            logger.error(f"SQS error for file {key}: {e}")
            raise

        # Send email with content
        try:
            sns.publish(
                TopicArn=sns_topic_arn,
                Message=content,
                Subject=f"Content from {key}"
            )
            logger.info(f"Email sent for file {key}")
        except ClientError as e:
            logger.error(f"SNS error for file {key}: {e}")
            raise

        return {
            'statusCode': 200,
            'body': json.dumps('File processed and data sent to RDS, SQS, and SNS.')
        }
    except Exception as e:
        logger.error(f"An error occurred: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('An error occurred while processing the S3 event.')
        }
