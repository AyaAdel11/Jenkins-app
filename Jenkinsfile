pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'AyaAdel11' 
        IMAGE_NAME      = 'jenkins-app'
        IMAGE_TAG       = "${env.BUILD_NUMBER}"
        DOCKER_CREDS_ID = 'dockerhub' 
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
