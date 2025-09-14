pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-amazon-corretto.x86_64'
        PATH = "${JAVA_HOME}/bin:${PATH}"
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

        stage('Run CI') {
            steps {
                script {
                    def ci = load "${WORKSPACE}/Jenkinsfile-CI"
                    ci.runCI()
                }
            }
        }

        stage('Run CD') {
            steps {
                script {
                    def cd = load "${WORKSPACE}/Jenkinsfile-CD"
                    cd.runCD()
                }
            }
        }
    }
}
