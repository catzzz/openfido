[
    {
        "name": "${task_name}",
        "image": "${task_image_name}",
        "essential": true,
        "memoryReservation": 512,
        "environment": [
            {"name": "S3_BUCKET", "value": "${S3_BUCKET}"},
            {"name": "FLASK_APP", "value": "${FLASK_APP}"},
            {"name": "SYSTEM_FROM_EMAIL_ADDRESS", "value": "${SYSTEM_FROM_EMAIL_ADDRESS}"},
            {"name": "FLASK_ENV", "value": "${FLASK_ENV}"},
            {"name": "SQLALCHEMY_DATABASE_URI", "value": "${SQLALCHEMY_DATABASE_URI}"},
            {"name": "EMAIL_DRIVER", "value": "${EMAIL_DRIVER}"},
            {"name": "SENDGRID_API_KEY", "value": "${SENDGRID_API_KEY}"},
            {"name": "CLIENT_BASE_URL", "value": "${CLIENT_BASE_URL}"},
            {"name": "S3_PRESIGNED_TIMEOUT", "value": "${S3_PRESIGNED_TIMEOUT}"},
            {"name": "SECRET_KEY", "value": "${SECRET_KEY}"},
            {"name": "SENDGRID_PASSWORD_RESET_TEMPLATE_ID", "value": "${SENDGRID_PASSWORD_RESET_TEMPLATE_ID}"},
            {"name": "SENDGRID_ORGANIZATION_INVITATION_TEMPLATE_ID", "value": "${SENDGRID_ORGANIZATION_INVITATION_TEMPLATE_ID}"}
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group_name}",
                "awslogs-region": "${log_group_region}",
                "awslogs-stream-prefix": "${prefix}"
            }
        },
        "portMappings": [
            {
                "containerPort": 5000,
                "hostPort": 5000
            }
        ]

    }
]
