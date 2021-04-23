///s3 bucket upload artifcats code pipeline
pipeline {
    agent any 
    environment {
        environment {
        NAME = "docker-test-server-12345"
        VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
        DOCKER_IMAGE  = "${NAME}:${VERSION}"
        CONTINER_NAME = "${NAME}:${env.BUILD_ID}"
    }
        //DOCKER_IMAGE = "docker-test-server-12345"
        //CONTAINER_NAME = "server-test-41"
        //GIT_BRANCH = "java-webapp"
        ///DOCKERHUB = credentials('dockerhub')
        //HUB_CRED = credentials('dockerhubpwd')
    //}
    stages {
        stage ('Clone Repository') {
            steps {
                echo "Checkout Git Repo"
            // git credentialsId: 'github', url: 'https://github.com/radhakrishna4687/:${GITHUB_BRANCH}'
                git 'https://github.com/radhakrishna4687/docker-k8s-web-app.git'
                echo "Completed the Checkout the Git"
                sh "pwd"
            }
        }
        stage ('Maven Build WAR file') {
            steps {
                sh '''
                    mvn -f /var/lib/jenkins/workspace/artifacts-upload-s3-pipeline/pom.xml clean package
                '''
                //cp /var/lib/jenkins/workspace/artifacts-upload-s3-pipeline/target/*.war /home/ec2-user/
                echo "Sucessfully Compile Java code and generated WAR file"
            }
        }
        stage ('Upload Artifacts toAWS S3 Bucket') {
            steps {
                    sh '''
                        aws s3api list-buckets
                        aws s3 mb s3://test-env-webaps
                        aws s3 cp  /var/lib/jenkins/workspace/artifacts-upload-s3-pipeline/target/*.war s3://test-env-webaps
                    '''
                    echo "Sucessfully upload the artifacyts to S3 buckets"
            }
        }
        stage ('Build Docker Image') {
            steps {
                sh '''
                    docker build . -t ${DOCKER_IMAGE} 
                    docker images
                ''' 
                echo "Sucessfully Build the Docker Image"
                //sh "docker build .  -t radhakrishna4687/test-image-1:${DOCKER_TAG} "
            }
        }
        stage ('Run the Docker Container') {
            steps {
                sh '''
                    docker run -itd --name=${CONTAINER_NAME} -p 8091:8080 ${DOCKER_IMAGE}
                    docker ps 
                '''    
                echo "sucessfully run the Docker Container"
            }
        }
        stage ('Docker image push to Dockerhub Repository') {
            steps {
                sh 'docker tag ${DOCKER_IMAGE} radhakrishna4687/test-java-web-app:0.2'
                echo 'Fetching the AWS Secret Managers key In Text format'
                sh 'aws secretsmanager get-secret-value --secret-id dockerhubpwd --query SecretString --output text'
                sh '''
                    aws secretsmanager list-secrets --output json
                    aws secretsmanager describe-secret --secret-id dockerhubpwd
                    aws secretsmanager list-secret-version-ids --secret-id dockerhubpwd
                    aws secretsmanager list-secrets
                '''    
                echo 'Sucessfully fetch the AWS secret Key'
                echo "Sucessfully Build the Docker Image"
            }
        }
        stage ('Push docker image to DockerHub') {
            steps {
                //withCredentials([usernamePassword(credentialsId: '${HUB_CRED}',usernameVariable: '${HUB_CRED_USR}', passwordVariable: '${HUB_CRED_PSW}')]) {
                withDockerRegistry([ credentialsId: 'dockerhubpwd', url: '' ]) {
                //script {
                  //  username = sh (script: "aws secretsmanager get-secret-value --region us-east-1 --secret-id dockerhubpwd | jq -r .SecretString | jq -r .username", returnStdout: true)
                 //   password = sh (script: "aws secretsmanager get-secret-value --region us-east-1 --secret-id dockerhubpwd | jq -r .SecretString | jq -r .password", returnStdout: true)
               // withCredentials([usernamePassword(credentialsId: '${DOCKERHUB}',usernameVariable: 'DOCKER_USR', passwordVariable: 'DOCKER_PSW')]) {
                //withDockerRegistry([ credentialsId: "${HUB_CRED_USR}:${HUB_CRED_PSW}", url: "" ]) {
                //withDockerRegistry([ credentialsId: "dockerhub", url: "" ]) {
                //withCredentials([string(credentialsId: 'dockerhubcred', variable: 'dockerhubpwd')]) {
                //withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhubpwd')])
                    //sh 'sudo su -p root'
                   // sh 'docker login --username radhakrishna4687  --password-stdin ${dockerhubpwd}'
                        //sh 'docker push radhakrishna4687/harikrishna-web-app:v3'
                    sh 'docker push radhakrishna4687/test-java-web-app:0.2'
                    echo "Sucessfully Push the  Docker Image to Docker Private Repo"
                }
            }
        }
        //stage ('Docker remove contaner and image') {
         //   steps {
            //    sh '''
              //      docker stop ${CONTAINER_NAME} 
              //      docker rm ${CONTAINER_NAME} --force
                //    docker rmi ${DOCKER_IMAGE} --force
                //'''    
           // }
       // }
      //  stage ('Deploy Application in k8s Cluster') {
          //  steps {
        //        kubernetesDeploy(
          //      configs: 'deployement.yml',
            //    kubeconfigId: 'KUBERNETES_CLUSTER_CONFIG',
              //  enableConfigSubstitution: true
               // )
          //  }
            
      //  }

    }
}