pipeline {
    agent any
    stages {
        stage('Run CI') {
            steps {
                echo "Starting CI pipeline..."
                script {
                    // Load and execute the CI Jenkinsfile
                    load 'Jenkinsfile-CI'
                }
            }
        }

        stage('Run CD') {
            steps {
                echo "Starting CD pipeline..."
                script {
                    // Load and execute the CD Jenkinsfile
                    load 'Jenkinsfile-CD'
                }
            }
        }
    }
}
