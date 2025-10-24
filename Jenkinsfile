pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKERHUB_USER = 'adischi123'
        IMAGE_NAME = 'nextflix'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/adisch1/nextflix.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def commitHash = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def imageTag = "${DOCKERHUB_USER}/${IMAGE_NAME}:${commitHash}"

                    sh """
                    echo "Building Docker image: ${imageTag}"
                    docker build -t ${imageTag} .
                    docker tag ${imageTag} ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Login to DockerHub & Push') {
            steps {
                script {
                    def commitHash = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def imageTag = "${DOCKERHUB_USER}/${IMAGE_NAME}:${commitHash}"

                    sh """
                    echo "${DOCKERHUB_CREDENTIALS_PSW}" | docker login -u "${DOCKERHUB_CREDENTIALS_USR}" --password-stdin
                    docker push ${imageTag}
                    docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
                    docker logout
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Docker image built and pushed successfully!"
        }
        failure {
            echo "❌ Build failed. Check logs above."
        }
    }
}
