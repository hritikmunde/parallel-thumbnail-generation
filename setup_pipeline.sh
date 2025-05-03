#!/bin/bash

# This script sets up the full pipeline for the thumbnail generator project.
# WARNING: Assumes AWS credentials and ECR repo already set and AWS CLI + kubectl + helm are configured.

set -e

echo "=== STEP 1: Build and Push Docker Images ==="
docker buildx build --platform linux/amd64 -t flask-api .
docker tag flask-api:latest 172287740255.dkr.ecr.us-east-2.amazonaws.com/flask-api:latest
docker push 172287740255.dkr.ecr.us-east-2.amazonaws.com/flask-api:latest

docker buildx build --platform linux/amd64 -f Dockerfile.worker -t celery-worker .
docker tag celery-worker:latest 172287740255.dkr.ecr.us-east-2.amazonaws.com/celery-worker:latest
docker push 172287740255.dkr.ecr.us-east-2.amazonaws.com/celery-worker:latest

echo "=== STEP 2: Apply Kubernetes Manifests ==="
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/redis-deployment.yaml
kubectl apply -f k8s/redis-service.yaml
kubectl apply -f k8s/flask-api-deployment.yaml
kubectl apply -f k8s/flask-api-service.yaml
kubectl apply -f k8s/celery-worker-deployment.yaml
kubectl apply -f k8s/hpa.yaml

echo "=== STEP 3: Setup Monitoring (Optional if already configured) ==="
kubectl create namespace monitoring || true
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

echo "=== STEP 4: Wait and Get Load Balancer URL ==="
kubectl get svc -n thumbnail-generator

echo "=== STEP 5: Done. Use test.bash to perform load testing once LoadBalancer is ready."
