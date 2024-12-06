import boto3
import json
import os
import pandas as pd
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Iniciando o processamento do arquivo")
    s3_client = boto3.client('s3')
    cache_client = boto3.client('elasticache')

    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    logger.info(f"Baixando arquivo {key} do bucket {bucket}")

    # Baixar o arquivo
    file_path = f"/tmp/{key}"
    s3_client.download_file(bucket, key, file_path)

    # Ler o arquivo e processar
    df = pd.read_csv(file_path, header=None)
    logger.info(f"Arquivo {key} contém {len(df)} linhas")

    # Exemplo de armazenamento em ElastiCache
    cache_client.set('file_info', json.dumps({"filename": key, "num_lines": len(df)}))

    logger.info("Processamento concluído com sucesso")
    return {
        'statusCode': 200,
        'body': json.dumps('File processed successfully!')
    }
