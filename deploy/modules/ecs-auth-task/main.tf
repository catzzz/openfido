resource "aws_cloudwatch_log_group" "ecs_task_logs" {
  name = "${var.prefix}-auth-log"

  tags = var.common_tags
}

resource "random_password" "secret" {
  length           = 20
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>:?"
  keepers          = {
    pass_version = 1
  }
}

data "template_file" "api_container_definitions" {
  template = file("${path.module}/templates/container-definitions.json.tpl")

  depends_on = [var.db_endpoint]

  vars = {
    task_name = "${var.prefix}-${var.environment}-${var.task_name}-task"
    task_image_name = "${var.ecr_base_url}/${var.prefix}/stage-${var.task_name}:${var.image_tag}"
    
    // env
    CLIENT_BASE_URL                              = var.cf_domain
    EMAIL_DRIVER                                 = "sendgrid"
    FLASK_APP                                    = "run.py"
    FLASK_ENV                                    = "production"
    S3_BUCKET                                    = var.s3_blob_name
    S3_PRESIGNED_TIMEOUT                         = 3600
    SECRET_KEY                                   = random_password.secret.result
    SQLALCHEMY_DATABASE_URI                      = "postgresql://${var.db_user}:${var.db_password}@${var.db_endpoint}/${var.task_name}service"
    SYSTEM_FROM_EMAIL_ADDRESS                    = "support@openfido.org"
    // TODO: Change to secrets, for this they should be read it as JSON
    SENDGRID_API_KEY                             =  var.sendgrid_api_key
    SENDGRID_PASSWORD_RESET_TEMPLATE_ID          =  var.sendgrid_password_rest_template_id
    SENDGRID_ORGANIZATION_INVITATION_TEMPLATE_ID =  var.sendgrid_organization_invitation_template_id

    log_group_name    = aws_cloudwatch_log_group.ecs_task_logs.name
    log_group_region  = data.aws_region.current.name


    prefix = var.prefix
    containerPort = var.ecs_container_port 
    hostPort = var.ecs_host_port

    allowed_hosts     = "*"
  }
}

resource "aws_ecs_task_definition" "auth" {
  family                   = "${var.prefix}-${var.environment}-auth-service"
  container_definitions    = data.template_file.api_container_definitions.rendered
  requires_compatibilities = ["FARGATE","EC2"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  depends_on = [ var.aws_iam_role_task_execution_role_arn,  var.aws_iam_role_app_iam_role_arn]
  # execution_role_arn       = aws_iam_role.task_execution_role.arn
  # task_role_arn            = aws_iam_role.app_iam_role.arn
  execution_role_arn       = var.aws_iam_role_task_execution_role_arn
  task_role_arn            = var.aws_iam_role_app_iam_role_arn
  volume {
    name = "static"
  }

  tags = var.common_tags
}


resource "aws_security_group" "auth_service" {
  description = "Access for the ECS service"


  name        = "${var.prefix}-${var.task_name}-service"
  depends_on  =[var.vpc_id]
  vpc_id      = var.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    #  need to change to variable
    cidr_blocks = ["10.12.1.0/24", "10.12.2.0/24"]
    # cidr_blocks = [
    #   aws_subnet.private_a.cidr_block,
    #   aws_subnet.private_b.cidr_block,
    # ]
  }

  ingress {
    from_port   = var.ecs_host_port
    to_port     = var.ecs_host_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

resource "aws_ecs_service" "auth" {

  name            = "${var.prefix}-${var.task_name}-service"
  depends_on = [var.vpc_public_subnets,var.ecs_cluster_name]
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.auth.family
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets = [
      "${element(var.vpc_public_subnets, 0)}",
      "${element(var.vpc_public_subnets, 1)}"
      # aws_subnet.public_a.id,
      # aws_subnet.public_b.id,
    ]
    security_groups  = [aws_security_group.auth_service.id]
    assign_public_ip = true
  }
}
