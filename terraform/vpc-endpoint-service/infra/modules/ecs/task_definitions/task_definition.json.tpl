[
    {
        "name": "${CONTAINER_NAME}",
        "cpu": ${CPU},
        "memory": ${MEMORY},
        "image": "${DOCKER_IMAGE}",
        "portMappings" : [
          {
            "containerPort" : ${APP_PORT},
            "hostPort" : ${APP_PORT}
          }
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-region": "${REGION}",
            "awslogs-group": "${AWSLOGS_GROUP_NAME}",
            "awslogs-stream-prefix": "${CONTAINER_NAME}"
          }
        }
    }
]
