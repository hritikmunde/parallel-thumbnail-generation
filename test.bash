#!/bin/bash

# Improved load testing script for thumbnail-generator
# Author: Project Group

API_URL="http://a2be5583956cb4ddf97ac0e5d0311d06-378332701.us-east-2.elb.amazonaws.com:5000/upload"
IMAGE_FILE="test.jpg"
TOTAL_REQUESTS=200
CONCURRENCY=20

# Check if image exists
if [ ! -f "$IMAGE_FILE" ]; then
  echo "Error: $IMAGE_FILE not found!"
  exit 1
fi

upload_image() {
  local retry=0
  while [ $retry -lt 3 ]; do
    response=$(curl -s -X POST "$API_URL" \
      -F "file=@$IMAGE_FILE" \
      -H "Content-Type: multipart/form-data")
    if echo "$response" | grep -q "uploaded"; then
      echo "Success"
      break
    else
      echo "Upload failed, retry $retry"
      sleep 1
      ((retry++))
    fi
  done
  sleep 0.05  # Gently slow down to prevent sudden spike
}

# Main uploader
for ((i=1; i<=TOTAL_REQUESTS; i++)); do
  upload_image &
  
  if (( i % CONCURRENCY == 0 )); then
    wait
  fi
done

wait
echo "Completed $TOTAL_REQUESTS uploads with concurrency $CONCURRENCY"
