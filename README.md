# SWE645 – Homework Assignment 2
# Student Survey Web Application – Containerization, Kubernetes & CI/CD Pipeline
# Author: Sai Nishitha Muraharisetty | Course: SWE645

## What This Is
Student Survey web application containerized with Docker, deployed on Kubernetes 
with 3 pods for high availability, and automated with a Jenkins CI/CD pipeline 
that automatically builds and deploys on every GitHub commit.

## Tech Stack
- HTML/CSS Web Application (Student Survey Form)
- Apache Tomcat 9 (WAR deployment)
- Docker + Docker Hub
- Kubernetes (Rancher on AWS EC2)
- Jenkins CI/CD (AWS EC2)
- GitHub (Source Control)

## Links
- GitHub: https://github.com/nishitha1312/swe645-hw2
- Docker Hub: https://hub.docker.com/r/nishitha1312/studentsurvey645
- Jenkins: http://ec2-34-229-129-25.compute-1.amazonaws.com:8080

## Project Structure
```
swe645-hw2/
├── WebContent/             # HTML/CSS source files (WAR is built by Jenkins)
│   ├── index.html          # Main survey page
│   ├── survey.html         # Survey form page
│   ├── error.html          # Error page
│   ├── MyPic.png           # Image asset
│   └── WEB-INF/
│       └── web.xml         # Web application configuration
├── Dockerfile              # Docker image build instructions
├── Jenkinsfile             # CI/CD pipeline definition
└── k8s/
    ├── namespace.yaml      # Kubernetes namespace
    ├── deployment.yaml     # 3-replica deployment for resiliency
    └── service.yaml        # LoadBalancer service for external access
```

## How CI/CD Works
1. Developer pushes code change to GitHub
2. Jenkins detects change (polls every minute)
3. Jenkins builds WAR file from WebContent/ source files
4. Jenkins builds Docker image and tags with timestamp
5. Jenkins pushes image to Docker Hub
6. Jenkins deploys new image to Kubernetes using kubectl
7. Kubernetes performs rolling update with zero downtime
8. All 3 pods updated automatically

## How to Deploy Manually

### Step 1 - Apply Kubernetes manifests:
```
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml -n studentsurvey645
kubectl apply -f k8s/service.yaml -n studentsurvey645
```

### Step 2 - Check pods are running:
```
kubectl get pods -n studentsurvey645
```

### Step 3 - Access the app:
```
kubectl port-forward svc/studentsurvey-service 8080:8080 -n studentsurvey645
```
Then open: http://localhost:8080/StudentSurvey/index.html

## Pod Resiliency Test
```
# Delete a pod - Kubernetes will automatically create a replacement
kubectl delete pod <pod-name> -n studentsurvey645
kubectl get pods -n studentsurvey645 --watch
```

## CI/CD Pipeline Stages
1. Checkout Source Code - pulls latest from GitHub
2. Build WAR File - compiles source into StudentSurvey.war
3. Build Docker Image - creates image tagged with timestamp
4. Push to Docker Hub - uploads image with timestamp and latest tags
5. Deploy to Kubernetes - rolling update via kubectl set image
6. Verify Deployment - confirms all 3 pods are running
