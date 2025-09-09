pipeline {
    agent any
    tools {
        maven 'Maven3'  // This name must match the Maven installation name above
        jdk 'Default'   // Optional, if you also configured a JDK
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
