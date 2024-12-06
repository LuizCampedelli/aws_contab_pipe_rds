import boto3

def upload_to_s3(file_name, bucket_name):
    s3 = boto3.client('s3')
    try:
        s3.upload_file(file_name, bucket_name, file_name)
        print(f"Upload de {file_name} para {bucket_name} concluído com sucesso.")
    except Exception as e:
        print(f"Erro durante o upload: {e}")

def main():
    bucket_name = "mybucketuqz5k2sj1182001"  # Nome do bucket S3
    filename = "/mybucketuqz5k2sj1182001/lambda.zip"  # Caminho para o arquivo a ser enviado

    print(f"Bucket Name: {bucket_name}")  # Debug
    print(f"File Name: {filename}")        # Debug

    upload_to_s3(filename, bucket_name)

if __name__ == "__main__":
    main()
