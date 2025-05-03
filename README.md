# Thumbnail Generator with Kubernetes Autoscaling

This project is a production-style, cloud-native thumbnail generator system that uses Flask, Celery, and Redis to process image uploads and generate thumbnails in parallel. The system is fully containerized, deployed on AWS EKS using Terraform, and evaluated using Kubernetes Horizontal Pod Autoscaler (HPA) with both CPU and custom metrics (Redis queue depth). The monitoring stack includes Prometheus and Grafana.

---

## 📦 Technologies Used

- **Flask**: Python web server for image uploads
- **Celery**: Distributed task queue for parallel image resizing
- **Redis**: Broker between Flask and Celery
- **AWS S3**: Object storage for uploaded and processed images
- **Docker & ECR**: Containerization and registry
- **Kubernetes & EKS**: Deployment and orchestration
- **Terraform**: Infrastructure-as-Code for provisioning
- **Prometheus + Grafana**: Monitoring and dashboarding

---

## 🚀 How It Works

1. Users upload images through a Flask endpoint.
2. Flask uploads the original image to S3 and enqueues the filename to Redis.
3. Celery workers pick up the task, download the image, resize it, upload the thumbnail, and delete the original from S3.
4. The number of Celery workers scales dynamically using Kubernetes HPA (CPU-based or custom metrics).
5. Metrics are collected by Prometheus and visualized in Grafana dashboards.

---

## ⚙️ Prerequisites

- AWS CLI configured with ECR, EKS, and IAM permissions
- Terraform installed
- Helm installed
- Docker installed with buildx support
- `kubectl` configured for your EKS cluster

---

## 📄 `.gitignore` (Key Entries)

```
*.pyc
__pycache__/
.env
*.env
*.log
*.pem
*.zip
__pycache__/
.DS_Store
.envrc
*.db
*.sqlite3
terraform.tfstate*
.terraform/
.idea/
.vscode/
k8s/secrets.yaml
```

---

## 🛠️ Usage Instructions

### 1. Clone the Repo and Set Up Environment
```bash
git clone <repo-url>
cd thumbnail-generator
```

### 2. Set Up Terraform Infrastructure
```bash
cd terraform
terraform init
terraform apply
```

This will provision the VPC, EKS cluster, IAM roles, and output the EKS kubeconfig.

### 3. Deploy the Complete System
Run the automation script to build, push, and deploy everything:
```bash
chmod +x setup_pipeline.sh
./setup_pipeline.sh
```

This script will:
- Build Docker images for Flask and Celery
- Push to AWS ECR
- Apply Kubernetes manifests for Redis, Flask, Celery, HPA
- Set up Prometheus and Grafana with Helm
- Expose services via LoadBalancer and print their URLs

### 4. Load Testing
```bash
chmod +x test.bash
./test.bash
```

This runs a batch of concurrent uploads (configurable) to test scaling and stress the pipeline.

---

## 📊 Monitoring

Access Grafana at the printed LoadBalancer URL (default port 3000). Use dashboards to view:
- HPA replica scaling
- Redis queue depth
- CPU usage
- Upload/resize rates

---

## 📥 API Endpoint

Upload an image:
```bash
curl -X POST <FLASK_LB_URL>/upload -F "file=@test.jpg"
```

---

## 👨‍💻 Team Contributions

| Name | Contributions |
|------|---------------|
| Aditya Dhumal | Prometheus, provisioning, benchmarking |
| Anish Wadkar | Flask app, Redis integration |
| Hritik Munde | Load testing, HPA tuning, Terraform |
| Amey Parle | Grafana, monitoring dashboards, analysis |

---

## 🧪 Future Work

- Integrate Redis queue metrics for custom HPA scaling
- Enable persistent queues (e.g., Kafka/RQ)
- Auto-retry failed S3 uploads
- Add CloudWatch-based cost insights
- Expand monitoring dashboards

---

## 📂 File Structure

```
.
├── flask-app/
├── celery-worker/
├── terraform/
├── k8s/
├── test.bash
├── setup_pipeline.sh
└── README.md
```

---

## 🧹 Cleanup

Run:
```bash
terraform destroy
```

Delete ECR images, S3 buckets, ENIs manually if Terraform fails due to dependencies.

---

## 📌 Notes

- Use `kubectl get hpa` and `kubectl top pods` to manually inspect scaling.
- For debugging, check logs:
```bash
kubectl logs deployment/flask-api -n thumbnail-generator
kubectl logs deployment/celery-worker -n thumbnail-generator
```

---

## 📸 Screenshots

Include architecture diagrams and Grafana dashboards here if submitting for demo or reports.

---

## 🔒 Secrets

Store secrets like AWS keys in Kubernetes secrets (avoid committing `.env` or `secrets.yaml`).

---

## 🏁 Conclusion

This project demonstrates real-world HPA tuning, parallel processing, and observability in Kubernetes using a minimal yet scalable image processing pipeline.