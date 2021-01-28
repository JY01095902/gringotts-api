
#! /usr/bin/expect  

set timeout 30  
set TAG_NAME [lindex $argv 0]
set CONTAINER_NAME "t2hut-gringotts-api-stg"

# spawn sudo su - root
# expect "*Password:"
# send "***\r"

# expect "#"
spawn docker login --username=$env(DEPLOY_DOCKER_REPOSITORY_USERNAME) $env(DEPLOY_DOCKER_REPOSITORY_ADDRESS)

expect "*Password:"
send "$env(DEPLOY_DOCKER_REPOSITORY_PASSWORD)\r"

expect "#"
spawn docker push $TAG_NAME

expect "#"
spawn ssh -l root $env(DEPLOY_SERVER_IP)

expect {
    "*yes/no*" { send "yes\r"; exp_continue }
    "*password:" { send "$env(DEPLOY_SERVER_PASSWORD)\r" }
}

expect "#"
send "docker login --username=$env(DEPLOY_DOCKER_REPOSITORY_USERNAME) $env(DEPLOY_DOCKER_REPOSITORY_ADDRESS)\r"

expect "*Password:"
send "$env(DEPLOY_DOCKER_REPOSITORY_PASSWORD)\r"

expect "#"
send "docker pull $TAG_NAME\r"

# 发布 API
expect "#"
send "docker stop $CONTAINER_NAME\r"

expect "#"
send "docker rm $CONTAINER_NAME\r"

expect "#"
send "docker run --name $CONTAINER_NAME -d -p 9297:9297 \
    --restart=always \
    --network=t2hut-network \
    --ip=172.18.1.4 \
    -e ENV=development \
    -e GRINGOTTS_MONGO_IP=$env(GRINGOTTS_MONGO_IP) \
    -e GRINGOTTS_MONGO_PORT=$env(GRINGOTTS_MONGO_PORT) \
    -e GRINGOTTS_MONGO_DB_NAME=$env(GRINGOTTS_MONGO_DB_NAME) \
    -e GRINGOTTS_MONGO_USERNAME=$env(GRINGOTTS_MONGO_USERNAME) \
    -e GRINGOTTS_MONGO_PASSWORD=$env(GRINGOTTS_MONGO_PASSWORD) \
    $TAG_NAME\r"

expect "#"
send "exit\r"

# interact
expect eof