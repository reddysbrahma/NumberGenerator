node{
   stage('SCM Checkout'){
       git credentialsId: 'git-brahma', url: 'https://github.com/reddysbrahma/NumberGenerator.git'
   }
   stage('Mvn Package'){
     def mvnHome = tool name: 'maven-3', type: 'maven'
     def mvnCMD = "${mvnHome}/bin/mvn"
     sh "${mvnCMD} clean package"
   }
   sh " sh gettheversion.sh > commandResult"
   artifact = readFile('commandResult').trim()
   stage('Build Docker Image'){
     sh "docker build -t reddysbrahma/num-gen:${artifact} ."
   }
   stage('Push Docker Image'){
     withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
        sh "docker login -u reddysbrahma -p ${dockerHubPwd}"
     }
     sh "docker push reddysbrahma/num-gen:${artifact}"
   }
   stage('Remove Old Containers'){
    sshagent(['dev-server']) {
      try{
        def sshCmd = 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.47'
        def dockerRM = 'docker rm -f num-gen'
        sh "${sshCmd} ${dockerRM}"
      }catch(error){

      }
    }
  }
   stage('Run Container on Dev Server'){
     def dockerRun = "docker run -p 8081:8080 -d --name num-gen reddysbrahma/num-gen:${artifact}"
     sshagent(['dev-server']) {
       sh "ssh -o StrictHostKeyChecking=no ec2-user@172.31.43.47 ${dockerRun}"
     }
   }
}
