pipeline {
    agent any

    // Tools configuration
    tools {
        maven 'Maven3'   // Must match the Maven installation name in Jenkins Global Tool Configuration
        jdk 'Default'    // Optional, use if you have a JDK configured
    }

    stages {

        // ----------------------------
        stage('Run CI') {
            steps {
                script {
                    // Load your CI function-style Jenkinsfile
                    def ci = load 'Jenkinsfile-CI'
                    ci.runCI()   // Execute the CI pipeline
                }
            }
        }

        // ----------------------------
        stage('Run CD') {
            steps {
                script {
                    // Load your CD function-style Jenkinsfile
                    def cd = load 'Jenkinsfile-CD'
                    cd.runCD()   // Execute the CD pipeline
                }
            }
        }

    } // end stages

    // Optional: post actions
    post {
        always {
            echo "Pipeline finished. Check build logs for details."
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Please check logs and fix issues."
        }
    }
}
