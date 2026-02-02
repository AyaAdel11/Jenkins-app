pipeline {
    agent any

    environment {
			APP_NAME = 'jenkins-app'
        	RELEASE = "1.0.0"
            DOCKER_USER = "ayaadel02"
            DOCKER_PASS = 'dockerhub'
            IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
            IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}" 
    }

  stages {
		stage("Cleanup Workspace"){
			steps {
				cleanWs()
			}
		}

		stage("Checkout from SCM"){
			steps {
				git branch: 'main', credentialsId: 'github', url: 'https://github.com/AyaAdel11/Jenkins-app.git'
			}
		}

		stage("Build Application"){
            steps {
                sh "mvn clean package"
            }

       }
		
		stage("Test Application"){
           steps {
                 sh "mvn test"
           }
       }
	  
		stage("Build & Push Docker Image") {
		    steps {
		        script {
		            
		            sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
		            sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
		
		            withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
		                sh "echo \$PASS | docker login -u \$USER --password-stdin"
		                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
		                sh "docker push ${IMAGE_NAME}:latest"
		            }
		        }
		    }
		}
	  stage("Update Deployment File") {
            steps {
                script {
                    sh "sed -i 's|image: ${IMAGE_NAME}:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' deployment.yaml"
                }
            }
        }

        stage("Deploy to K8s") {
            steps {
                sh "kubectl apply -f deployment.yaml"
            }
        }

        stage("Cleanup Local Images") {
            steps {
                sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest || true"
            }
        }



  }

    post {
        always {
            echo 'Pipeline execution finished.'
        }
        success {
            echo 'Deployment successful! Application is live.'
        }
        failure {
            echo 'Pipeline failed. Please check the Console Output.'
        }
    }
}
