#!/bin/bash

set -e  # Exit on error

NAMESPACE="nlmontes14-dev"

echo "Deploying Helm charts to namespace: $NAMESPACE"

helm upgrade --install "payment-platform" "deployment/charts/payment-platform" \
  -f "deployment/values/payment-platform-values.yaml" \
  --namespace "$NAMESPACE"

helm upgrade --install "activemq" "deployment/charts/activemq" \
  -f "deployment/values/activemq-values.yaml" \
  --namespace "$NAMESPACE"

helm upgrade --install "redis-cache" "deployment/charts/redis-cache" \
  -f "deployment/values/redis-cache-values.yaml" \
  --namespace "$NAMESPACE"

echo "All services deployed successfully."
