
# Thumbnail Generator with Horizontal Pod Autoscaling (HPA) on Kubernetes

## Overview

This project demonstrates a **cloud-native, scalable image processing system** designed to evaluate **Kubernetes Horizontal Pod Autoscaling (HPA)** efficiency.

We built:

- A **Flask** API server for image uploads.
- A **Celery** distributed worker system.
- A **Redis** queue.
- Persistent storage on **AWS S3**.
- Deployment automated via **Terraform** and run on **AWS EKS (Elastic Kubernetes Service)**.

We simulate **dynamic workloads** and study system scaling behavior.

---

# System Architecture

- **User** uploads image via Flask API
- **Flask API** saves file to `/tmp`, uploads to S3 `uploads/` folder
- **Filename** pushed to **Redis** queue
- **Celery worker**:
  - Downloads image from S3
  - Resizes it
  - Uploads resized image to S3 `thumbnails/` folder
  - Deletes original upload after resizing

---

# Technologies Used

- **Python** (Flask, Celery, Boto3)
- **Redis** (message broker)
- **Docker** (containerization)
- **AWS S3** (object storage)
- **AWS ECR** (container registry)
- **AWS EKS** (Kubernetes cluster)
- **Terraform** (Infrastructure as Code)
- **Kubernetes HPA** (Horizontal Pod Autoscaling)

---

# Local Setup (Docker Compose)

1. **Create `.env` file:**

   ```bash
   AWS_ACCESS_KEY_ID=your_access_key
   AWS_SECRET_ACCESS_KEY=your_secret_key
   AWS_S3_BUCKET_NAME=your_bucket_name
   AWS_REGION=us-east-2
   SECRET_KEY=your_secret_key
   REDIS_URL=redis://redis:6379/0
   ```

2. **Docker Compose:**

   ```bash
   docker-compose up --build
   ```

3. **Test API locally:**

   ```bash
   curl -X POST http://localhost:5000/upload -F "file=@/path/to/your/image.jpg"
   ```

---

# Docker Image Build and Push (AWS ECR)

1. **Authenticate ECR:**

   ```bash
   aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin <your_account_id>.dkr.ecr.us-east-2.amazonaws.com
   ```

2. **Build and push Flask API:**

   ```bash
   docker buildx build --platform linux/amd64 -t flask-api .
   docker tag flask-api:latest <your_account_id>.dkr.ecr.us-east-2.amazonaws.com/flask-api:latest
   docker push <your_account_id>.dkr.ecr.us-east-2.amazonaws.com/flask-api:latest
   ```

3. **Build and push Celery Worker:**

   ```bash
   docker buildx build --platform linux/amd64 -f Dockerfile.worker -t celery-worker .
   docker tag celery-worker:latest <your_account_id>.dkr.ecr.us-east-2.amazonaws.com/celery-worker:latest
   docker push <your_account_id>.dkr.ecr.us-east-2.amazonaws.com/celery-worker:latest
   ```

---

# Kubernetes Setup

1. **Provision Cluster with Terraform** (example steps):

   - Create VPC, Subnets, Route Tables
   - Create EKS Cluster + Node Groups
   - Attach IAM roles (ECR, S3 Access)

2. **Kubernetes YAMLs** (`k8s/` folder):

   - `namespace.yaml` (create `thumbnail-generator` namespace)
   - `redis-deployment.yaml`
   - `redis-service.yaml`
   - `flask-api-deployment.yaml`
   - `flask-api-service.yaml` (LoadBalancer)
   - `celery-worker-deployment.yaml`
   - `secrets.yaml` (AWS keys, REDIS_URL)
   - `hpa.yaml` (for Celery autoscaling)

3. **Apply YAMLs:**

   ```bash
   kubectl apply -f k8s/namespace.yaml
   kubectl apply -f k8s/secrets.yaml
   kubectl apply -f k8s/redis-deployment.yaml
   kubectl apply -f k8s/redis-service.yaml
   kubectl apply -f k8s/flask-api-deployment.yaml
   kubectl apply -f k8s/flask-api-service.yaml
   kubectl apply -f k8s/celery-worker-deployment.yaml
   kubectl apply -f k8s/hpa.yaml
   ```

4. **Find LoadBalancer IP:**

   ```bash
   kubectl get svc -n thumbnail-generator
   ```

---

# Testing on Kubernetes

1. **Upload an image:**

   ```bash
   curl -X POST http://<LoadBalancer_DNS>:5000/upload -F "file=@/path/to/image.jpg"
   ```

2. **Check S3 Bucket:**

   - You should see the resized image under `thumbnails/`
   - No original file remains (auto-deletion after resize)

3. **Monitor HPA:**

   ```bash
   kubectl get hpa -n thumbnail-generator
   ```

4. **Debugging:**

   ```bash
   kubectl logs deployment/flask-api -n thumbnail-generator
   kubectl logs deployment/celery-worker -n thumbnail-generator
   ```

5. **Exec into Pods if needed:**

   ```bash
   kubectl exec -it <pod-name> -n thumbnail-generator -- /bin/sh
   ```

---

# Key Improvements Done

- Parallel task processing with Celery
- Redis Queue with retry behavior
- S3 uploads and cleaned up originals
- Multi-architecture Docker builds for AWS
- Complete Infrastructure as Code (Terraform)
- Horizontal Pod Autoscaling (CPU-based for now)
- Debugging and Monitoring with Kubernetes tools

---

# Future Improvements

- Add Prometheus Adapter to autoscale based on **Redis Queue Depth**.
- Optimize Celery concurrency settings.
- Add Grafana dashboards for live system visualization.
- Introduce CloudWatch alarms for cost monitoring.

---

# Authors

- Aditya Dhumal
- Anish Wadkar
- Hritik Munde
- Amey Parle

---

# References

- Kubernetes Documentation: [https://kubernetes.io/docs/](https://kubernetes.io/docs/)
- Terraform Registry: [https://registry.terraform.io/](https://registry.terraform.io/)
- AWS Documentation: [https://aws.amazon.com/documentation/](https://aws.amazon.com/documentation/)

---

# Final Note

This project highlights cloud-native principles of **dynamic autoscaling**, **parallel processing**, and **fault-tolerant distributed systems**.
