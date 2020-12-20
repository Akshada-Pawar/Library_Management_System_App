pipeline {
    agent none
    options {
        skipStagesAfterUnstable()
    }
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
            post{
                always{
                    junit 'test-reports/result.xml'
                }
            }
        }
        stage('Deliver') {
            agent any {
                environment {
                    VOLUME = '$ (pwd)/sources:/src'
                    IMAGE =  'cdrx/pyinstaller-linux:python3'
                }
            }
            steps {
                dir(path: env.BUILD_ID){
                    unstash(name: 'compiled-results')
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F library.py'"

                }
            }
            post{
                success{
                    archiveArtifacts "${env.BUILD_ID}/sources/dist/library"
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
                }
            }
        }
    }
}




