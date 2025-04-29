from . import celery
from PIL import Image
import boto3
import os
from .config import Config

@celery.task()
def resize_and_upload_image(filename):
    try:
        s3 = boto3.client(
            's3',
            aws_access_key_id=Config.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=Config.AWS_SECRET_ACCESS_KEY,
            region_name=Config.AWS_REGION
        )

        # Paths
        download_path = os.path.join('/tmp', filename)
        resized_path = os.path.join('/tmp', f"resized-{filename}")

        # 1. Download the original file from S3 uploads/
        s3.download_file(
            Config.AWS_S3_BUCKET_NAME,
            f"uploads/{filename}",
            download_path
        )

        print(f"Downloaded {filename} from S3.")

        # 2. Open and resize the image
        img = Image.open(download_path)
        img.thumbnail(Config.THUMBNAIL_SIZE)
        img.save(resized_path)
        print(f"Resized {filename}.")

        # 3. Upload the resized image to S3 thumbnails/
        s3.upload_file(
            resized_path,
            Config.AWS_S3_BUCKET_NAME,
            f"thumbnails/{filename}",
            ExtraArgs={'ACL': 'private'}
        )
        print(f"Uploaded thumbnail {filename} to S3.")

        # 4. Delete the original upload from uploads/
        s3.delete_object(
            Bucket=Config.AWS_S3_BUCKET_NAME,
            Key=f"uploads/{filename}"
        )
        print(f"Deleted original upload {filename} from S3.")

        # Clean up local tmp files
        os.remove(download_path)
        os.remove(resized_path)

    except Exception as e:
        print(f"Error processing file {filename}: {str(e)}")
