from flask import Blueprint, request, jsonify
from werkzeug.utils import secure_filename
from .tasks import resize_and_upload_image
import os

# Blueprint for API routes
main = Blueprint('main', __name__)

# Allowed extensions (basic check)
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# API Route for uploading an image
@main.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({"error": "No file part in the request"}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file_path = os.path.join('/tmp', filename)  # Save temporarily on container filesystem
        file.save(file_path)

        # Queue task to Celery
        resize_and_upload_image.delay(file_path, filename)

        return jsonify({"message": "File uploaded successfully, processing started!"}), 202

    else:
        return jsonify({"error": "File type not allowed"}), 400
