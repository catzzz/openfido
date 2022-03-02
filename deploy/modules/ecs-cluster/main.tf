
resource "aws_ecs_cluster" "main" {

  name = "${var.prefix}-${var.environment}-ecs-cluster"

  tags = var.aws_tags
}

 
resource "aws_iam_policy" "task_execution_role_policy" {
  name        = "${var.prefix}-task-exec-role-policy"
  path        = "/"
  description = "Allow retrieving images and adding to logs"
  policy      = file("${path.module}/templates/task-exec-role.json")
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${var.prefix}-task-exec-role"
  assume_role_policy = file("${path.module}/templates/assume-role-policy.json")
}

resource "aws_iam_role_policy_attachment" "task_execution_role" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_role_policy.arn
}

resource "aws_iam_role" "app_iam_role" {
  name               = "${var.prefix}-api-task"
  assume_role_policy = file("${path.module}/templates/assume-role-policy.json")

  tags = var.aws_tags
}
