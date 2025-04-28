import os

class Config:
    # Flask secret key (optional for sessions, not critical here)
    SECRET_KEY = os.environ.get('SECRET_KEY', 'default_secret_key')

    # Redis broker URL for Celery
    REDIS_URL = os.environ.get('REDIS_URL', 'redis://localhost:6379/0')

    task_default_queue_type = "classic" 

    # AWS S3 configuration
    AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY')
    AWS_S3_BUCKET_NAME = os.environ.get('AWS_S3_BUCKET_NAME')
    AWS_REGION = os.environ.get('AWS_REGION', 'us-east-2')  # Default to your region

    # Thumbnail settings (optional)
    THUMBNAIL_SIZE = (128, 128)  # 128x128 pixels