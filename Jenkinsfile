pipeline {
    agent any
    environment {
        // Set JAVA_HOME to the Corretto 17 JDK on your EC2 agent
        JAVA_HOME = '/usr/lib/jvm/java-17-amazon-corretto.x86_64'
        PATH = "${env.JAVA_HOME}/bin:${env.PATH}"
    }
    tools {
        maven 'Maven3'  // Jenkins Maven tool name
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
