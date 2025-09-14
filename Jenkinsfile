pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-amazon-corretto.x86_64'
        PATH = "${JAVA_HOME}/bin:${PATH}"
        DOCKER_USERNAME = 'logeshwaran2025'
    }

    tools {
        maven 'Maven3'
    }

    stages {
        stage('Checkout Repository') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: 'https://github.com/LOGESHWARAN2025/DevopsProject1.git']]])
            }
        }

        stage('CI: Build & Docker') {
            steps {
                script {
                    dir('DevopsProject1') {
                        sh 'mvn clean install'

                        sh "docker build -t ${DOCKER_USERNAME}/ci-cd-pipeline:${BUILD_NUMBER} ."
                        sh "docker tag ${DOCKER_USERNAME}/ci-cd-pipeline:${BUILD_NUMBER} ${DOCKER_USERNAME}/ci-cd-pipeline:latest"
                    }
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials',
                                                     usernameVariable: 'DOCKER_USER',
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${DOCKER_USERNAME}/ci-cd-pipeline:${BUILD_NUMBER}
                            docker push ${DOCKER_USERNAME}/ci-cd-pipeline:latest
                        """
                    }
                }
            }
        }

        stage('CD: Copy & Deploy to Kubernetes') {
            steps {
                script {
                    def NODE_IP = "13.233.21.199"
                    def EC2_USER = "ec2-user"

                    sshagent(['my_ec2_creds']) {
                        sh """
                            scp -o StrictHostKeyChecking=no ${WORKSPACE}/DevopsProject1/deployment.yaml ${EC2_USER}@${NODE_IP}:/home/${EC2_USER}/
                            scp -o StrictHostKeyChecking=no ${WORKSPACE}/DevopsProject1/service.yaml ${EC2_USER}@${NODE_IP}:/home/${EC2_USER}/
                        """
                    }

                    input message: "Approve deployment to Kubernetes?"

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
            sh 'docker image prune -af || true'
        }
    }
}
