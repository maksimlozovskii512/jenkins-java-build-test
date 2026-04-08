pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK17'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 20, unit: 'MINUTES')
    }

    environment {
        APP_DIR = 'spring-boot-demo'
        MAVEN_OPTS = '-Dmaven.repo.local=.m2/repository'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                dir("${APP_DIR}") {
                    sh 'mvn -B clean verify'
                }
            }
        }

        stage('Package Artifact') {
            steps {
                dir("${APP_DIR}") {
                    sh 'mvn -B package -DskipTests'
                }
            }
        }

        stage('Deploy Snapshots') {
            when {
                branch 'main'
            }
            steps {
                dir("${APP_DIR}") {

                    withCredentials([usernamePassword(
                        credentialsId: 'nexus-deploy',
                        usernameVariable: 'NEXUS_USER',
                        passwordVariable: 'NEXUS_PASS'
                    )]) {

                        configFileProvider([
                            configFile(fileId: 'maven-settings-nexus', targetLocation: 'settings.xml')
                        ]) {

                            sh '''
                                set -e

                                mvn -B -s settings.xml deploy -DskipTests
                            '''
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            junit "${APP_DIR}/**/target/surefire-reports/*.xml"
        }

        success {
            archiveArtifacts artifacts: "${APP_DIR}/target/*.jar", fingerprint: true
        }
    }
}   