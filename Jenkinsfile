pipeline {
    agent {
        label '( linux || sw.os.linux ) && ( x64 || x86_64 || x86 || hw.arch.x86 ) && ( docker || sw.tool.docker ) && !test'
    }
    stages {
        stage('checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build cross-compilation OS') {
            steps {
                sh "docker build -t ev3dev-lang-java:jdk-stretch -f system/Dockerfile system "
            }
        }
        stage("Build cross-compilation environment") {
            steps {
                sh "docker build -t ev3dev-lang-java:jdk-build -f scripts/Dockerfile scripts "
            }
        }
        stage("Test") {
            steps {
                sh "rm -rf    /home/jenkins/workspace/" + JOB_NAME + "/build"
                sh "mkdir -p  /home/jenkins/workspace/" + JOB_NAME + "/build"
                sh "chmod 777 /home/jenkins/workspace/" + JOB_NAME + "/build"
                sh "docker run --rm -v /home/jenkins/workspace/" + JOB_NAME + "/build:/build -e JDKVER='" + JDKVER_VALUE + "' -e JDKVM='client' -e AUTOBUILD='1' ev3dev-lang-java:jdk-build"
            }
        }
        post {
    	always {
			step([$class: "TapPublisher", testResults: "**/*.tap"])
			junit allowEmptyResults: true, keepLongStdio: true, testResults: '**/work/**/*.jtr.xml, **/junitreports/**/*.xml'
			
		}
		unstable {
			archiveArtifacts artifacts: '**/*.tap', fingerprint: true, allowEmptyArchive: true
			archiveArtifacts artifacts: '**/work/**/*.jtr, **/junitreports/**/*.xml', fingerprint: true, allowEmptyArchive: true
		}
 	}
    }
}
