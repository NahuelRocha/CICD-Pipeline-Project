pipeline {
    agent any

    tools {
        maven 'maven3'
        jdk 'jdk17'
    }

    environment {
            SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {

        stage('Git Checkout') {
             steps {
                git branch: 'main', url: 'https://github.com/NahuelRocha/CICD-Pipeline-Project.git'
            }
        }

        stage('Compile') {
            steps {
                sh  "mvn compile"
            }
        }

        stage('Test') {
            steps {
                sh "mvn test"
            }
        }

        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs --format table -o fs.html ."
            }
        }


        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                   sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=CiCd -Dsonar.projectKey=CiCd \
                        -Dsonar.java.binaries=target '''
                }
            }
        }

        stage('Package') {
            steps {
                sh "mvn package"
            }
        }

        stage('Publish To Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh "mvn deploy"
                }
            }
        }

        stage('Docker Build & Tag') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker build -t rochanahuel/newpipeline:latest ."
                    }
                }
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh "trivy image --format table -o image.html rochanahuel/newpipeline:latest"
            }
        }

        stage('Docker Push Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker push rochanahuel/newpipeline:latest"
                    }
                }
            }
        }
    }
}
