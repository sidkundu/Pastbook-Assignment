pipeline
    {
        options
        {
            buildDiscarder(logRotator(numToKeepStr: '3'))
        }
        agent any
        environment 
        {
            PROJECT = 'myproject'
            TAG = "${env.BUILD_NUMBER}"
            REPO_URL = '083139177360.dkr.ecr.eu-central-1.amazonaws.com/myproject'
            REGION = 'eu-central-1'
        }
        stages
        {
            stage('Checkout code') {
                steps {
                    checkout scm
                }
            }   

            stage('Build preparations')
            {
                steps
                {
                    script 
                    {
                        // calculate GIT lastest commit short-hash
                        gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                        shortCommitHash = gitCommitHash.take(7)
                        // calculate a sample version tag
                        VERSION = shortCommitHash
                        // set the build display name
                        currentBuild.displayName = "#${BUILD_ID}-${VERSION}"
                        IMAGE = "$PROJECT:$VERSION"
                    }
                }
            }
            stage('Docker build/push')
            {
                steps
                {
                    script
                    {
                        sh("webapp/ecr/build.sh './helm/app' $REPO_URL:$TAG $REGION")
                    }
                }
            }

            stage('Deploy')
            {
                steps
                {
                    script
                    {
                     sh("./helm/app/deploy.sh")

                    }
                }
            }
        }    

        post
        {
            always
            {
                // make sure that the Docker image is removed
                sh "docker rmi $REPO_URL:$TAG | true"
            }
        }
    } 

