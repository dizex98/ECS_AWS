resource "aws_ecs_cluster" "my_cluster" {
  name = "itay-cluster"
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "hello-world-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "hello-world"
      image     = "public.ecr.aws/c7l4l0y6/itay-hello-world:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }])
}

resource "aws_ecs_service" "my_service" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = [aws_subnet.private_subnet_1.id,aws_subnet.private_subnet_2.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_tg.arn
    container_name   = "hello-world"
    container_port   = var.app_port
  }

}