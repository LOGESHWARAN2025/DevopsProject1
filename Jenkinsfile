pipeline {
    agent any
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
