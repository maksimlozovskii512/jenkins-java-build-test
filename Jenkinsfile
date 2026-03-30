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

                    withCredentials([usernamePassword(
                        credentialsId: 'nexus-deploy',
                        usernameVariable: 'NEXUS_USER',
                        passwordVariable: 'NEXUS_PASS'
                    )]) {

                        sh '''
                        # fail fast if creds missing
                        if [ -z "$NEXUS_USER" ] || [ -z "$NEXUS_PASS" ]; then
                            echo "Missing Nexus credentials"
                            exit 1
                        fi

                        # generate settings.xml dynamically
                        cat > settings.xml <<EOF
<settings>
  <servers>
    <server>
      <id>nexus-snapshots</id>
      <username>${NEXUS_USER}</username>
      <password>${NEXUS_PASS}</password>
    </server>
  </servers>
</settings>
EOF

                        mvn -B -s settings.xml deploy -DskipTests
                        '''
                    }
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