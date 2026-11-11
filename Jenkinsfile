
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
                        set +x
                        export DOCKER_CONFIG="$(mktemp -d)"
                        trap 'docker logout >/dev/null 2>&1 || true; rm -rf "$DOCKER_CONFIG"' EXIT
                        printf '%s' "$DOCKER_TOKEN" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag $IMAGE:$BUILD_NUMBER $IMAGE:latest
                        docker push $IMAGE:$BUILD_NUMBER
                        docker push $IMAGE:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image successfully published!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
