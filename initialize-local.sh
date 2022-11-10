#!/bin/bash

########################################################################
# NOTES: Run this on your local 'rancher' cluster.                     #
# This will initialize all things Carbide on your downstream clusters. #
########################################################################

echo "Labeling the local cluster as 'carbide=enabled'.."
kubectl patch clusters -n fleet-local local -p '{"metadata":{"labels":{"carbide":"enabled"}}}' --type=merge

echo "Creating the Carbide namespace.."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: carbide
  labels:
    name: carbide
EOF

echo "Creating Git chart repo deployment.."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: carbide-charts
  namespace: carbide
  labels:
    app: carbide-charts
spec:
  replicas: 3
  selector:
    matchLabels:
      app: carbide-charts
  template:
    metadata:
      labels:
        app: carbide-charts
    spec:
      containers:
      - name: carbide-charts
        image: harbor.atoy.dev/public/carbide-charts:1.0
        ports:
        - name: http
          containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: carbide-charts
  namespace: carbide
spec:
  selector:
    app: carbide-charts
  ports:
    - protocol: TCP
      port: 80
      targetPort: http
EOF

echo "Creating Gitrepo to trigger umbrella flow.."
cat <<EOF | kubectl apply -f -
kind: GitRepo
apiVersion: fleet.cattle.io/v1alpha1
metadata:
  name: carbide-charts
  namespace: fleet-local
spec:
  repo: http://carbide-charts.carbide.svc.cluster.local/git/git-http-backend.git
  targets:
  - clusterSelector:
      matchExpressions:
      - key: carbide
        operator: In
        values:
        - enabled
  paths:
  - "./carbide/umbrella"
EOF