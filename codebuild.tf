resource "aws_codebuild_project" "example" {
  name          = "itay-hello-world"
  description   = "codeBuild for my hello world project"
  build_timeout = "5"
  service_role  = aws_iam_role.code_build_service_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/dizex98/ECS_AWS.git"

  }

  source_version = "main"

#   cache {
#     type     = "S3"
#     location = aws_s3_bucket.example.bucket
#   }

#   logs_config {
#     cloudwatch_logs {
#       group_name  = "log-group"
#       stream_name = "log-stream"
#     }

#     s3_logs {
#       status   = "ENABLED"
#       location = "${aws_s3_bucket.example.id}/build-log"
#     }
#  }

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

# Here you can see the CodeBuild base policy and AmazonEC2ContainerRegistryFullAccess policy combined.
  
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
        "Action": [
            "ecr:*",
            "cloudtrail:LookupEvents"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "iam:CreateServiceLinkedRole"
        ],
        "Resource": "*",
        "Condition": {
            "StringEquals": {
                "iam:AWSServiceName": [
                    "replication.ecr.amazonaws.com"
                ]
            }
        }
    }
    ]
}
POLICY
}