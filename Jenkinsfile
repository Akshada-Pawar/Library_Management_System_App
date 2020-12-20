pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'python:3-alpine'
                }
            }
            steps {
                sh 'python -m py_compile sources/library.py'
                stash(name: 'compiled-results', includes: 'sources/*.py*')
            }
        }
        stage('Test') { 
            agent {
                docker {
                    image 'qnib/pytest' 
                }
            }
            steps {
                sh 'py.test --junit-xml test-reports/results.xml sources/library_test.py' 
            }
        }
        stage('Email'){
            always{
            success{
                mail to:"pawarakshada13@gmail.com", subject:"SUCCESS ${currentBuild.fullDisplayName}", body: "More info at: ${env.BUILD_URL} All test cases are passed."
            }
            failure{
                mail to:"pawarakshada13@gmail.com", subject:"FAILURE ${currentBuild.fullDisplayName}", body: "More info at: ${env.BUILD_URL} Test cases are failed."
            }
            }
        }
        
    }
}