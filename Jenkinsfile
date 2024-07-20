pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/git-volk/sf_tasks.git'
        FILE_PATH = 'project_10/index.html'
        DOCKER_IMAGE = 'nginx:latest'
        CONTAINER_NAME = 'nginx_test'
        HOST_PORT = '9889'
        CONTAINER_PORT = '80'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git branch: 'main', url: "${REPO_URL}"
                }
            }
        }
        
        stage('Start Docker Container') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE}").run("-d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT}")
                }
            }
        }

        stage('Copy index.html to Container') {
            steps {
                script {
                    sh "docker cp ${FILE_PATH} ${CONTAINER_NAME}:/usr/share/nginx/html/index.html"
                }
            }
        }

        stage('Check HTTP Response') {
            steps {
                script {
                    def response = httpRequest url: "http://localhost:${HOST_PORT}/index.html"
                    if (response.status != 200) {
                        error "HTTP response status is not 200"
                    }
                }
            }
        }

        stage('Compare MD5 Sums') {
            steps {
                script {
                    def localMd5 = sh(script: "md5sum ${FILE_PATH} | awk '{print \$1}'", returnStdout: true).trim()
                    def containerMd5 = sh(script: "docker exec ${CONTAINER_NAME} md5sum /usr/share/nginx/html/index.html | awk '{print \$1}'", returnStdout: true).trim()

                    if (localMd5 != containerMd5) {
                        error "MD5 sums do not match"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                sh "docker rm -f ${CONTAINER_NAME}"
            }
        }
    }
}
