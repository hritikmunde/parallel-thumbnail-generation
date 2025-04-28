from app import celery, create_app

# Create Flask app context
app = create_app()

# Attach app context to celery
app.app_context().push()
