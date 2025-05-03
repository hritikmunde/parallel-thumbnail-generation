from flask import Blueprint, request, jsonify
from werkzeug.utils import secure_filename
import boto3
import os
from .config import Config
from .tasks import resize_and_upload_image

main = Blueprint('main', __name__)
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@main.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({"error": "No file part in request"}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file_path = os.path.join('/tmp', filename)
        try:
            file.save(file_path)

            # Upload immediately to S3
            s3 = boto3.client(
                's3',
                aws_access_key_id=Config.AWS_ACCESS_KEY_ID,
                aws_secret_access_key=Config.AWS_SECRET_ACCESS_KEY,
                region_name=Config.AWS_REGION
            )
            s3.upload_file(
                file_path,
                Config.AWS_S3_BUCKET_NAME,
                f"uploads/{filename}",
                ExtraArgs={'ACL': 'private'}
            )
            print(f"Uploaded {filename} to uploads/ successfully")

            os.remove(file_path)

            # Queue resizing
            resize_and_upload_image.delay(filename)

            return jsonify({"message": "File uploaded and resize task started!"}), 202
        except Exception as e:
            print(f"Failed uploading {filename}: {e}")
            if os.path.exists(file_path):
                os.remove(file_path)
            return jsonify({"error": "Failed uploading to S3"}), 500
    else:
        return jsonify({"error": "File type not allowed"}), 400
