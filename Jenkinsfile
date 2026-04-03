pipeline {
  agent any

  parameters {
    choice(name: 'TF_ACTION', choices: ['plan', 'apply', 'destroy', 'none'], description: 'Terraform action')
    booleanParam(name: 'RUN_APP_DEPLOY', defaultValue: false, description: 'Set true to run app build/push/deploy after TF')
  }

  environment {
    AWS_REGION      = 'ap-south-1'  // Replace with your AWS region
    AWS_ACCOUNT_ID  = '123456789012'  // Replace with your AWS account ID
    REGISTRY        = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    IMAGE_NAME      = 'tic-tac-toe-ecr'
    IMAGE_TAG       = "${env.BUILD_NUMBER ?: 'latest'}"
    FULL_IMAGE      = "${env.REGISTRY}/${env.IMAGE_NAME}:${IMAGE_TAG}"
    ECS_CLUSTER     = 'tic-tac-toe-cluster'
    ECS_SERVICE     = 'tic-tac-toe-service'
    TASK_FAMILY     = 'tic-tac-toe'
  }

  options {
    ansiColor('xterm')
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '30'))
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/your-username/tic-tac-toe-aws.git'  // Replace with your actual repository URL
      }
    }

    stage('Terraform') {
      steps {
        script {
          dir('terraform') {
            sh 'terraform init -input=false'
            if (params.TF_ACTION == 'plan') {
              sh 'terraform plan -input=false'
            } else if (params.TF_ACTION == 'apply') {
              sh "terraform apply -auto-approve -input=false -var=\"image_tag=latest\""
            } else if (params.TF_ACTION == 'destroy') {
              sh 'terraform destroy -auto-approve -input=false'
            } else {
              echo 'Skipping Terraform (TF_ACTION=none)'
            }
          }
        }
      }
    }

    stage('Prepare') {
      when { expression { params.RUN_APP_DEPLOY == true } }
      steps {
        sh 'pwd && ls -la'
        sh 'cd frontend && ls -la'
      }
    }

    stage('Build Docker image') {
      when { expression { params.RUN_APP_DEPLOY == true } }
      steps {
        sh '''
          cd frontend
          docker build --pull -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${FULL_IMAGE} .
        '''
      }
    }

    stage('Registry login') {
      when { expression { params.RUN_APP_DEPLOY == true } }
      steps {
        sh '''
          aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REGISTRY}
        '''
      }
    }

    stage('Push image') {
      when { expression { params.RUN_APP_DEPLOY == true } }
      steps {
        sh 'docker push ${FULL_IMAGE}'
      }
    }

    stage('Update Terraform Image') {
      when { expression { params.RUN_APP_DEPLOY == true } }
      steps {
        dir('terraform') {
          sh "terraform apply -auto-approve -input=false -var=\"image_tag=${IMAGE_TAG}\""
        }
      }
    }

    stage('ECS Service Create/Update') {
      when { expression { params.RUN_APP_DEPLOY == true } }
      steps {
        sh '''
          cd terraform
          TG_ARN=$(terraform output -raw target_group_arn)
          PRIVATE_SUBNETS=$(terraform output -json private_subnets | jq -r '.[]' | paste -sd ',' -)
          ECS_SG=$(terraform output -raw ecs_security_group_id)
          cd ..

          if aws ecs describe-services --cluster ${ECS_CLUSTER} --services ${ECS_SERVICE} --query 'services[0].serviceName' --output text 2>/dev/null | grep -q ${ECS_SERVICE}; then
            aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --task-definition ${TASK_FAMILY} --force-new-deployment
          else
            aws ecs create-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --task-definition ${TASK_FAMILY} --desired-count 2 --launch-type FARGATE --network-configuration "awsvpcConfiguration={subnets=[${PRIVATE_SUBNETS}],securityGroups=[${ECS_SG}],assignPublicIp=DISABLED}" --load-balancers targetGroupArn=${TG_ARN},containerName=frontend,containerPort=80
          fi
        '''
      }
    }

    stage('Verify Deployment') {
      when { expression { params.RUN_APP_DEPLOY == true } }
      steps {
        sh '''
          aws ecs wait services-stable --cluster ${ECS_CLUSTER} --services ${ECS_SERVICE}
          aws ecs describe-services --cluster ${ECS_CLUSTER} --services ${ECS_SERVICE} --query 'services[0].{status:status,runningCount:runningCount,desiredCount:desiredCount}'
        '''
      }
    }
  }

  post {
    always {
      sh '''
        if [ "${RUN_APP_DEPLOY}" = "true" ]; then
          docker image prune -f || true
          docker container prune -f || true
        fi
      '''
    }

    success {
      echo "Pipeline SUCCESS: ${FULL_IMAGE}"
    }

    failure {
      echo "Pipeline FAILURE"
    }
  }
}
