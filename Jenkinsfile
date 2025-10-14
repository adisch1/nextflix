pipeline {
    agent any

    environment {
        EC2_CREDENTIALS = credentials('ec2-ssh-key')
        IMAGE_NAME = "nextflix"
        AWS_REGION = "eu-central-1" 
        ECR_URL = "047719655761.dkr.ecr.eu-central-1.amazonaws.com/devops/nextflix"
        ECR_SURL = "047719655761.dkr.ecr.eu-central-1.amazonaws.com"
        STAGING_IP = "52.59.231.94"
        PROD_IP = "54.93.247.225"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/adisch1/nextflix.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t $IMAGE_NAME .
                docker tag $IMAGE_NAME:latest $ECR_URL/$IMAGE_NAME:latest
                """
            }
        }

        stage('Push to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_SURL
                docker push $ECR_URL/$IMAGE_NAME:latest
                """
            }
        }

        stage('Deploy to Staging') {
            when { branch 'main' }
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@$STAGING_IP \
                    'docker pull $ECR_URL/$IMAGE_NAME:latest && \
                     docker stop nextflix || true && \
                     docker rm nextflix || true && \
                     docker run -d --name nextflix -p 3000:3000 $ECR_URL/$IMAGE_NAME:latest'
                    """
                }
            }
        }

        stage('Deploy to Production') {
            when { 
                expression { return env.CHANGE_ID == null } // runs only on PR merge
            }
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@$PROD_IP \
                    'docker pull $ECR_URL/$IMAGE_NAME:latest && \
                     docker stop nextflix || true && \
                     docker rm nextflix || true && \
                     docker run -d --name nextflix -p 3000:3000 $ECR_URL/$IMAGE_NAME:latest'
                    """
                }
            }
        }
    }
}
