pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-amazon-corretto.x86_64'
        PATH = "${JAVA_HOME}/bin:${PATH}"
        DOCKER_USERNAME = 'logeshwaran2025'
        DOCKER_REPO = 'ci-cd-pipelines'
    }

    tools {
        maven 'Maven3'  // Must match the Maven installation name in Jenkins global tools
    }

    stages {

        stage('Checkout Repository') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: 'https://github.com/LOGESHWARAN2025/DevopsProject1.git']]])
            }
        }

        stage('CI: Maven Build & Test') {
            steps {
                script {
                    // Run Maven in workspace root
                    sh 'mvn clean test verify install'
                }
            }
        }

        stage('CI: Docker Build & Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials',
                                                     usernameVariable: 'DOCKER_USER',
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker build -t ${DOCKER_REPO}:${BUILD_NUMBER} .
                            docker tag ${DOCKER_REPO}:${BUILD_NUMBER} ${DOCKER_USERNAME}/${DOCKER_REPO}:v${BUILD_NUMBER}
                            docker tag ${DOCKER_REPO}:${BUILD_NUMBER} ${DOCKER_USERNAME}/${DOCKER_REPO}:latest
                        """
                    }
                }
            }
        }

        stage('CI: Docker Push') {
            steps {
                script {
                    sh """
                        docker push ${DOCKER_USERNAME}/${DOCKER_REPO}:v${BUILD_NUMBER}
                        docker push ${DOCKER_USERNAME}/${DOCKER_REPO}:latest
                    """
                }
            }
        }

        stage('CD: Copy Kubernetes Files to Node') {
            steps {
                script {
                    def NODE_IP = "13.233.21.199"
                    def EC2_USER = "ec2-user"
                    def PROJECT_NAME = "DevopsProject1"

                    sshagent(['my_ec2_creds']) {
                        sh """
                            scp -o StrictHostKeyChecking=no ${WORKSPACE}/deployment.yaml ${EC2_USER}@${NODE_IP}:/home/${EC2_USER}/
                            scp -o StrictHostKeyChecking=no ${WORKSPACE}/service.yaml ${EC2_USER}@${NODE_IP}:/home/${EC2_USER}/
                        """
                    }
                }
            }
        }

        stage('CD: Manual Approval') {
            steps {
                input message: "Approve deployment to Kubernetes?"
            }
        }

        stage('CD: Deploy to Kubernetes') {
            steps {
                script {
                    def NODE_IP = "13.233.21.199"
                    def EC2_USER = "ec2-user"

                    sshagent(['my_ec2_creds']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${NODE_IP} kubectl apply -f /home/${EC2_USER}/deployment.yaml
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${NODE_IP} kubectl apply -f /home/${EC2_USER}/service.yaml
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${NODE_IP} kubectl rollout restart deployment mydeploy
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${NODE_IP} kubectl get svc -o wide
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker images
            sh 'docker image prune -af || true'
        }
    }
}
