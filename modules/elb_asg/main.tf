# Security group global
resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = var.vpc_id
}



# Création du Security Group pour le load balancer

resource "aws_security_group" "Security_Group_ASG"{
  name = "Secu_Group_ASG"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.Security_Group_Load_Balancer.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Sécu group pour le load balancer
resource "aws_security_group" "Security_Group_Load_Balancer"{
  name = "Secu_Group_LB"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb_target_group" "alb_target_group" {
  name     = "tf-example-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "instance"

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Security_Group_Load_Balancer.id]
  subnets            = var.public_subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_launch_configuration" "asg_launch_config" {
  name_prefix          = "asg-launch-config"
  image_id             = var.ami_id
  instance_type        = "t2.micro"
  security_groups = [
  aws_security_group.Security_Group_ASG.id,
  aws_security_group.app_sg.id
  ]
  iam_instance_profile = var.iam_instance_profile
  key_name             = var.key_name
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1

  launch_configuration = aws_launch_configuration.asg_launch_config.name

  vpc_zone_identifier  = var.private_subnets

  target_group_arns = [aws_lb_target_group.alb_target_group.arn]

  health_check_type = "ELB"
}