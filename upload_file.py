import boto3

def upload_to_s3(file_name, bucket_name, object_name=None):
    """
    Upload a file to an S3 bucket

    :param file_name: File to upload
    :param bucket_name: Target S3 bucket
    :param object_name: S3 object name. If not specified, file_name is used
    :return: True if file was uploaded, else False
    """
    if object_name is None:
        object_name = file_name

    s3 = boto3.client('s3')

    try:
        # Upload the file
        s3.upload_file(file_name, bucket_name, object_name)
        print(f"Upload of {file_name} to bucket {bucket_name} as {object_name} completed successfully.")
    except Exception as e:
        print(f"Error during upload: {e}")

def main():
    bucket_name = "mybucketuqz5k2sj1182001"  # Name of your S3 bucket

    # Files to upload
    files_to_upload = [
        {"file_name": "pandas_layer.zip", "object_name": "lambda_layers/pandas_layer.zip"},
        {"file_name": "lambda.zip", "object_name": "lambda_functions/lambda.zip"},
        {"file_name": "lambda_dependencies.zip", "object_name": "llambda_dependencies/lambda_dependencies.zip"}
    ]

    # Upload each file
    for file_info in files_to_upload:
        file_name = file_info["file_name"]
        object_name = file_info["object_name"]
        print(f"Uploading {file_name} to bucket {bucket_name} at {object_name}...")  # Debug
        upload_to_s3(file_name, bucket_name, object_name)

if __name__ == "__main__":
    main()
