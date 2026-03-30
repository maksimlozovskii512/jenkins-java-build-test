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
                dir('spring-boot-demo') {
                    sh '''
                        mvn -version
                        mvn -B dependency:resolve
                    '''
                }
            }
        }

        stage('Build & Test') {
            steps {
                dir('spring-boot-demo') {
                    sh '''
                        mvn clean test
                    '''
                }
            }
        }
    }

    post {
        always {
            junit 'spring-boot-demo/**/target/surefire-reports/*.xml'
        }
    }
}