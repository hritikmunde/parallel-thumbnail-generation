from . import celery
from PIL import Image
import boto3
import os
from .config import Config

@celery.task()
def resize_and_upload_image(file_path, filename):
    try:
        # Open the original image
        img = Image.open(file_path)
        
        # Resize the image
        img.thumbnail(Config.THUMBNAIL_SIZE)

        # Save resized image temporarily
        resized_path = os.path.join('/tmp', f"resized-{filename}")
        img.save(resized_path)

        # Upload to S3
        s3 = boto3.client(
            's3',
            aws_access_key_id=Config.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=Config.AWS_SECRET_ACCESS_KEY,
            region_name=Config.AWS_REGION
        )

        # Upload file
        s3.upload_file(
            resized_path,
            Config.AWS_S3_BUCKET_NAME,
            f"thumbnails/{filename}",  # store inside 'thumbnails/' folder in bucket
            ExtraArgs={'ACL': 'private'}
        )

        # Clean up temporary files
        os.remove(file_path)
        os.remove(resized_path)

        print(f"Thumbnail {filename} uploaded successfully.")

    except Exception as e:
        print(f"Error processing file {filename}: {str(e)}")
