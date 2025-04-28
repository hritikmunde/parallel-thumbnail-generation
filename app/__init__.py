from flask import Flask
from celery import Celery
from .config import Config
from dotenv import load_dotenv
load_dotenv()

# Initialize Celery separately
celery = Celery(__name__, broker=Config.REDIS_URL)

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    from .routes import main as main_blueprint
    app.register_blueprint(main_blueprint)

    return app
