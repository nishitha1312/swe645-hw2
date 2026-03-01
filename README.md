# SWE645 – Assignment 2
**Student:** Sai Nishitha Muraharisetty  
**Course:** SWE645 – Software Engineering for the Web

---

## What This Is
Student Survey web application containerized with Docker, deployed on Kubernetes, and automated with a Jenkins CI/CD pipeline.

## Tech Stack
- Java WAR + Apache Tomcat 9
- Docker + Docker Hub
- Kubernetes (Rancher Desktop)
- Jenkins (AWS EC2)
- GitHub

## Links
- Docker Hub: https://hub.docker.com/r/nishitha1312/studentsurvey645
- Jenkins: http://ec2-34-229-129-25.compute-1.amazonaws.com:8080

## Project Structure
```
├── StudentSurvey.war       # Java web application
├── Dockerfile              # Docker image build instructions
├── Jenkinsfile             # CI/CD pipeline definition
└── k8s/
    ├── namespace.yaml      # Kubernetes namespace
    ├── deployment.yaml     # 3-replica deployment
    └── service.yaml        # LoadBalancer service
```

## How to Run

**1. Deploy to Kubernetes:**
```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

**2. Access the app:**
```bash
kubectl port-forward svc/studentsurvey-service 8080:8080 -n studentsurvey645
```
Then open: http://localhost:8080/StudentSurvey/survey.html

**3. Check pods:**
```bash
kubectl get pods -n studentsurvey645
```

## CI/CD Pipeline
Jenkins pulls from GitHub → builds Docker image → pushes to Docker Hub → deploys to Kubernetes.
