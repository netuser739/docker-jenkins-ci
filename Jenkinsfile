
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t cpp-jenkins-app .'
            }
        }

        stage('Test') {
            steps {
                sh '''
                    docker run --rm cpp-jenkins-app > output.txt
                    cat output.txt
                    grep -q "Hello from Docker and Jenkins!" output.txt
                '''
            }
        }

        stage('Verify') {
            steps {
                sh 'docker image inspect cpp-jenkins-app'
            }
        }
    }

    post {
        success {
            echo 'CI pipeline completed successfully!'
        }
        failure {
            echo 'CI pipeline failed!'
        }
    }
}
