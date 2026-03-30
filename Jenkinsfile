pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git 'git@github.com:maksimlozovskii512/jenkins-java-demo.git'
            }
        }

        stage('Setup & Build Dependencies') {
            steps {
                sh '''
                    mvn -version
                    mvn -B dependency:resolve
                '''
            }
        }

        stage('Build & Test') {
            steps {
                sh '''
                    mvn clean test
                '''
            }
        }
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml'
        }
    }
}