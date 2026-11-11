
pipeline {
    agent any

    environment {
        IMAGE = 'netuser739/cpp-jenkins-app'
    }

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t $IMAGE:$BUILD_NUMBER .'
            }
        }

        stage('Test') {
            steps {
                sh '''
                    docker run --rm $IMAGE:$BUILD_NUMBER > output.txt
                    cat output.txt
                    grep -q "Hello from Docker and Jenkins!" output.txt
                '''
            }
        }

        stage('Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_TOKEN'
                )]) {
                    sh '''
                        echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag $IMAGE:$BUILD_NUMBER $IMAGE:latest
                        docker push $IMAGE:$BUILD_NUMBER
                        docker push $IMAGE:latest
                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image successfully built and published!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
