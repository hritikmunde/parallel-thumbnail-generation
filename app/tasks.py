from . import celery
from PIL import Image
import boto3
import os
from .config import Config

@celery.task()
def resize_and_upload_image(filename):
    try:
        print(f"Starting resize for {filename}")

        s3 = boto3.client(
            's3',
            aws_access_key_id=Config.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=Config.AWS_SECRET_ACCESS_KEY,
            region_name=Config.AWS_REGION
        )

        # 🔥 Download original image from uploads/
        download_path = os.path.join('/tmp', filename)
        s3.download_file(
            Config.AWS_S3_BUCKET_NAME,
            f"uploads/{filename}",
            download_path
        )

        # 🔥 Open and resize
        img = Image.open(download_path)
        img.thumbnail(Config.THUMBNAIL_SIZE)

        # 🔥 Save resized version
        resized_path = os.path.join('/tmp', f"resized-{filename}")
        img.save(resized_path)

        # 🔥 Upload resized thumbnail to thumbnails/ folder
        s3.upload_file(
            resized_path,
            Config.AWS_S3_BUCKET_NAME,
            f"thumbnails/{filename}",
            ExtraArgs={'ACL': 'private'}
        )

        # Clean up
        os.remove(download_path)
        os.remove(resized_path)

        print(f"Thumbnail {filename} uploaded successfully.")

    except Exception as e:
        print(f"Error processing file {filename}: {str(e)}")
