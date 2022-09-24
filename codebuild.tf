resource "aws_codebuild_project" "codebuild_project" {
  name          = "itay-hello-world"
  description   = "CodeBuild for my hello world project"
  service_role  = aws_iam_role.code_build_service_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/dizex98/ECS_AWS.git"

  }

  source_version = "main"

  tags = {
    Environment = "Test"
  }
}

resource "aws_iam_role" "code_build_service_role" {
  name = "code-build-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "service_role_policy" {
  role = aws_iam_role.code_build_service_role.name
  name        = "CodeBuildBasePolicy"
  
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:eu-north-1:753392824297:log-group:/aws/codebuild/itay-hello-world",
        "arn:aws:logs:eu-north-1:753392824297:log-group:/aws/codebuild/itay-hello-world:*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::codepipeline-eu-north-1-*"
      ],
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases",
        "codebuild:BatchPutCodeCoverages"
      ],
      "Resource": [
        "arn:aws:codebuild:eu-north-1:753392824297:report-group/itay-hello-world-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "codestar-connections:UseConnection",
      "Resource": "arn:aws:codestar-connections:us-east-1:753392824297:connection/a79bf967-432f-407d-8fa1-336541b46300"
    }
    ]
}
POLICY
}

resource "aws_iam_policy_attachment" "ecr_attachment" {
  name       = "ecr-attachment"
  roles      = [aws_iam_role.code_build_service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_policy_attachment" "ecr_attachment2" {
  name       = "ecr-attachment2"
  roles      = [aws_iam_role.code_build_service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess"
}

resource "aws_iam_policy_attachment" "codebuild_s3_attachment" {
  name       = "s3-attachment"
  roles      = [aws_iam_role.code_build_service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}