pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git 'git@github.com:maksimlozovskii512/jenkins-java-demo.git'
            }
        }

        stage('Build, Test & Package') {
            steps {
                dir('spring-boot-demo') {
                    sh '''
                        mvn -version
                        mvn -B clean test package
                    '''
                }
            }
        }

        stage('Deploy to Nexus') {
            steps {
                dir('spring-boot-demo') {
                    sh '''
                        mvn -B deploy -DskipTests
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