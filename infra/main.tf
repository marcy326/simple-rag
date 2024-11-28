provider "aws" {
  region = var.aws_region
}

module "iam_chat_lambda" {
  source    = "./modules/iam"
  role_name = "chat_lambda_execution_role"
}

module "iam_vectorize_lambda" {
  source    = "./modules/iam"
  role_name = "vectorize_lambda_execution_role"
}

module "lambda_chat" {
  source                = "./modules/lambda"
  function_name         = "chat_lambda"
  lambda_role_arn       = module.iam_chat_lambda.lambda_role_arn
  environment_variables = { OPENAI_API_KEY = var.openai_api_key }
  timeout = 60
}

module "lambda_vectorize" {
  source                = "./modules/lambda"
  function_name         = "vectorize_lambda"
  lambda_role_arn       = module.iam_vectorize_lambda.lambda_role_arn
  environment_variables = {}
  timeout = 60
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  api_name          = "LambdaAPI"
  api_description   = "API Gateway for Lambda"
  resource_path             = "chat"
  lambda_arn                = module.lambda_chat.lambda_arn
  lambda_invoke_arn         = module.lambda_chat.lambda_invoke_arn
  stage_name  = var.stage_name
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  lambda_arn  = module.lambda_vectorize.lambda_arn
}

module "network" {
  source      = "./modules/network"
  vpc_cidr    = "10.20.0.0/16"
  subnet_cidr = "10.20.1.0/24"
}

# module "rds" {
#   source                   = "./modules/rds"
#   aurora_master_username   = var.aurora_master_username
#   aurora_database_name     = var.aurora_database_name
#   aurora_master_password   = var.aurora_master_password
#   security_group_id        = module.network.security_group_id
#   subnet_ids               = module.network.subnet_ids
# }
