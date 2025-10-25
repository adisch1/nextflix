pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKERHUB_USER = 'adischi123'
        IMAGE_NAME = 'nextflix'

        STAGING_HOST = '52.91.30.201'       
        PROD_HOST    = '34.224.165.248'         
        SSH_USER     = 'ubuntu'               
        APP_PORT     = '3000'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/adisch1/nextflix.git', credentialsId: 'github'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def commitHash = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    env.IMAGE_TAG = "${DOCKERHUB_USER}/${IMAGE_NAME}:${commitHash}"
                    sh """
                    echo "Building Docker image ${IMAGE_TAG}"
                    docker build -t ${IMAGE_TAG} .
                    docker tag ${IMAGE_TAG} ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh """
                    echo "${DOCKERHUB_CREDENTIALS_PSW}" | docker login -u "${DOCKERHUB_CREDENTIALS_USR}" --password-stdin
                    docker push ${IMAGE_TAG}
                    docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
                    docker logout
                    """
                }
            }
        }

        stage('Deploy to Staging') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${SSH_USER}@${STAGING_HOST} '
                        docker pull ${IMAGE_TAG} &&
                        docker stop nextflix || true &&
                        docker rm nextflix || true &&
                        docker run -d --name nextflix -p ${APP_PORT}:${APP_PORT} ${IMAGE_TAG}
                    '
                    """
                }
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
                expression { return currentBuild.changeSets.size() == 0 } // deploy only on merge
            }
            steps {
                script {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${SSH_USER}@${PROD_HOST} '
                        docker pull ${IMAGE_TAG} &&
                        docker stop nextflix || true &&
                        docker rm nextflix || true &&
                        docker run -d --name nextflix -p ${APP_PORT}:${APP_PORT} ${IMAGE_TAG}
                    '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check the logs above."
        }
    }
}
