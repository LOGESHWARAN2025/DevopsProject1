pipeline {
    agent any

    environment {
        // Set JAVA_HOME to Corretto 17 JDK on your EC2 agent
        JAVA_HOME = '/usr/lib/jvm/java-17-amazon-corretto.x86_64'
        PATH = "${JAVA_HOME}/bin:${PATH}"
    }

    tools {
        maven 'Maven3'  // Must match the Maven name in Jenkins global tools
    }

    stages {
        stage('Run CI') {
            steps {
                script {
                    def ci = load 'Jenkinsfile-CI'
                    ci.runCI()
                }
            }
        }

        stage('Run CD') {
            steps {
                script {
                    def cd = load 'Jenkinsfile-CD'
                    cd.runCD()
                }
            }
        }
    }
}
