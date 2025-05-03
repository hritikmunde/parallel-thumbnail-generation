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
        # Download file from S3
        download_path = os.path.join('/tmp', filename)
        s3.download_file(Config.AWS_S3_BUCKET_NAME, f"uploads/{filename}", download_path)

        # Resize
        img = Image.open(download_path)
        img.thumbnail(Config.THUMBNAIL_SIZE)
        resized_path = os.path.join('/tmp', f"resized-{filename}")
        img.save(resized_path)

        # Upload resized
        s3.upload_file(
            resized_path,
            Config.AWS_S3_BUCKET_NAME,
            f"thumbnails/{filename}",
            ExtraArgs={'ACL': 'private'}
        )
        print(f"Thumbnail {filename} uploaded successfully.")

        # Clean up originals
        s3.delete_object(Bucket=Config.AWS_S3_BUCKET_NAME, Key=f"uploads/{filename}")
        os.remove(download_path)
        os.remove(resized_path)

    except Exception as e:
        print(f"Error processing {filename}: {e}")
