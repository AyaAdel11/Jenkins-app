@Library('my-shared-library') _

pipeline {
    // 1. تحديد الـ Agent ليكون الـ Slave اللي أنشأتيه
    agent { label 'slave-node' }

    environment {
        APP_NAME = 'jenkins-app'
        DOCKER_USER = "ayaadel02"
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "1.0.0-${BUILD_NUMBER}"
    }

    stages {
        stage("Cleanup Workspace") {
            steps {
                cleanWs()
            }
        }

        stage("Checkout from SCM") {
            steps {
                // تأكدي من صحة اسم الـ credentialsId الخاص بجيت هاب
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/AyaAdel11/Jenkins-app.git'
            }
        }

        // 2. استخدام المكتبة في مرحلة الاختبار
        stage("Test Application") {
            steps {
                runUnitTest() 
            }
        }

        // 3. استخدام المكتبة لبناء التطبيق
        stage("Build Application") {
            steps {
                buildApp()
            }
        }

        // 4. بناء الصورة باستخدام المكتبة
        stage("Build Docker Image") {
            steps {
                buildImage("${IMAGE_NAME}:${IMAGE_TAG}")
                // عمل Tag للـ latest محلياً
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
            }
        }

        // 5. إضافة مرحلة الفحص (Security Scan) المطلوبة في اللاب
        stage("Security Scan") {
            steps {
                scanImage("${IMAGE_NAME}:${IMAGE_TAG}")
            }
        }

        // 6. رفع الصورة باستخدام المكتبة
        stage("Push Docker Image") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo \$PASS | docker login -u \$USER --password-stdin"
                    pushImage("${IMAGE_NAME}:${IMAGE_TAG}")
                    pushImage("${IMAGE_NAME}:latest")
                }
            }
        }

        stage("Update Deployment File") {
            steps {
                sh "sed -i 's|image: ${IMAGE_NAME}:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' deployment.yaml"
            }
        }

        // 7. النشر باستخدام المكتبة
        stage("Deploy to K8s") {
            steps {
                deployOnK8s("deployment.yaml")
            }
        }

        // 8. التنظيف باستخدام المكتبة
        stage("Cleanup Local Images") {
            steps {
                removeImageLocally("${IMAGE_NAME}:${IMAGE_TAG}")
                removeImageLocally("${IMAGE_NAME}:latest")
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
            echo 'Pipeline failed. Check Console Output.'
        }
    }
}
