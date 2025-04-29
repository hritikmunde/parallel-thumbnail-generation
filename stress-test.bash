#!/bin/bash

API_URL="http://a2be5583956cb4ddf97ac0e5d0311d06-378332701.us-east-2.elb.amazonaws.com:5000/upload"
IMAGE_FILE="test.jpg"
CONCURRENCY=20

for i in {1..500}; do
    curl -s -X POST "$API_URL" -F "file=@$IMAGE_FILE" \
        -H "Content-Type: multipart/form-data" &

    if (( i % CONCURRENCY == 0 )); then
        wait
    fi
done

wait
echo "Finished uploading 500 images."
