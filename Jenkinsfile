// Jenkinsfile - CI/CD Pipeline for SWE645 HW2 Student Survey Application
// Builds WAR from source, creates Docker image, pushes to DockerHub, deploys to Kubernetes
// Author: Sai Nishitha Muraharisetty | Course: SWE645

pipeline {
    agent any

    environment {
        DOCKERHUB_PASS    = credentials('docker-pass')
        DOCKERHUB_USER    = 'nishitha1312'
        IMAGE_NAME        = 'studentsurvey645'
        K8S_NAMESPACE     = 'studentsurvey645'
        DEPLOYMENT_NAME   = 'studentsurvey-deployment'
        CONTAINER_NAME    = 'studentsurvey'
        RANCHER_IP        = '54.164.91.52'
        RANCHER_CONTAINER = 'b4994e26564d'
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                checkout scm
                echo "Source code checked out successfully"
            }
        }

        stage('Build WAR File') {
            steps {
                script {
                    sh 'rm -f *.war'
                    sh 'cd WebContent && jar -cvf ../StudentSurvey.war .'
                    echo "WAR file built successfully"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def timestamp = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()
                    env.BUILD_TIMESTAMP = timestamp
                    sh "docker login -u ${DOCKERHUB_USER} -p ${DOCKERHUB_PASS}"
                    sh "docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${timestamp} ."
                    sh "docker tag ${DOCKERHUB_USER}/${IMAGE_NAME}:${timestamp} ${DOCKERHUB_USER}/${IMAGE_NAME}:latest"
                    echo "Docker image built: ${DOCKERHUB_USER}/${IMAGE_NAME}:${timestamp}"
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                script {
                    sh "docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${BUILD_TIMESTAMP}"
                    sh "docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest"
                    echo "Image pushed to Docker Hub successfully"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                        ssh -i /home/jenkins/swe645-key.pem -o StrictHostKeyChecking=no ubuntu@${RANCHER_IP} \
                        "sudo docker exec ${RANCHER_CONTAINER} kubectl set image deployment/${DEPLOYMENT_NAME} \
                        ${CONTAINER_NAME}=${DOCKERHUB_USER}/${IMAGE_NAME}:${BUILD_TIMESTAMP} \
                        -n ${K8S_NAMESPACE}"
                    """
                    sh """
                        ssh -i /home/jenkins/swe645-key.pem -o StrictHostKeyChecking=no ubuntu@${RANCHER_IP} \
                        "sudo docker exec ${RANCHER_CONTAINER} kubectl rollout status deployment/${DEPLOYMENT_NAME} -n ${K8S_NAMESPACE}"
                    """
                    echo "Deployed image: ${BUILD_TIMESTAMP}"
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    sh """
                        ssh -i /home/jenkins/swe645-key.pem -o StrictHostKeyChecking=no ubuntu@${RANCHER_IP} \
                        "sudo docker exec ${RANCHER_CONTAINER} kubectl get pods -n ${K8S_NAMESPACE}"
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed! Student Survey app is live on Kubernetes."
        }
        failure {
            echo "Pipeline failed. Check logs above for details."
        }
        always {
            sh "docker image prune -f"
        }
    }
}
