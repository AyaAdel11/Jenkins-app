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
                    docker.withRegistry('',DOCKER_PASS) {
                    	docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
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
