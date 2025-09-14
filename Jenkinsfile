pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-amazon-corretto.x86_64'
        PATH = "${JAVA_HOME}/bin:${PATH}"
        DOCKER_USERNAME = 'logeshwaran2025'
        DOCKER_REPO = 'ci-cd-pipelines'
    }

    tools {
        maven 'Maven3'
    }

    stages {

        stage('Checkout Repository') {
            steps {
                // Checkout your repo to workspace
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: 'https://github.com/LOGESHWARAN2025/DevopsProject1.git']]])
            }
        }

        stage('CI: Build, Test & Docker') {
            steps {
                dir('DevopsProject1') {
                    script {
                        // Maven unit & integration tests
                        sh 'mvn clean test verify install'

                        // Docker login and image build
                        withCredentials([usernamePassword(credentialsId: 'docker-credentials',
                                                         usernameVariable: 'DOCKER_USER',
                                                         passwordVariable: 'DOCKER_PASS')]) {
                            sh """
                                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                                docker build -t ${DOCKER_REPO}:${BUILD_NUMBER} .
                                docker tag ${DOCKER_REPO}:${BUILD_NUMBER} ${DOCKER_USERNAME}/${DOCKER_REPO}:v${BUILD_NUMBER}
                                docker tag ${DOCKER_REPO}:${BUILD_NUMBER} ${DOCKER_USERNAME}/${DOCKER_REPO}:latest
                                docker push ${DOCKER_USERNAME}/${DOCKER_REPO}:v${BUILD_NUMBER}
                                docker push ${DOCKER_USERNAME}/${DOCKER_REPO}:latest
                            """
                        }

                        // Optional Trivy scan (if installed)
                        sh "# trivy image ${DOCKER_USERNAME}/${DOCKER_REPO}:v${BUILD_NUMBER} > scan.txt || true"
                    }
                }
            }
        }

        stage('CD: Copy & Deploy to Kubernetes') {
            steps {
                script {
                    def NODE_IP = "13.233.21.199"
                    def EC2_USER = "ec2-user"
                    def PROJECT_NAME = "DevopsProject1"

                    // Copy deployment & service manifests to Node server
                    sshagent(['my_ec2_creds']) {
                        sh """
                            scp -o StrictHostKeyChecking=no ${WORKSPACE}/${PROJECT_NAME}/deployment.yaml ${EC2_USER}@${NODE_IP}:/home/${EC2_USER}/
                            scp -o StrictHostKeyChecking=no ${WORKSPACE}/${PROJECT_NAME}/service.yaml ${EC2_USER}@${NODE_IP}:/home/${EC2_USER}/
                        """
                    }

                    // Manual approval before deployment
                    input message: "Approve deployment to Kubernetes?"

                    // Apply deployment on Node
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
            // Clean up Docker images locally
            sh 'docker image prune -af || true'
        }
    }
}
