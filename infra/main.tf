provider "aws" {
  region = var.AWS_REGION
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
  environment_variables = { OPENAI_API_KEY = var.OPENAI_API_KEY }
  timeout               = 60
}

module "lambda_vectorize" {
  source                = "./modules/lambda"
  function_name         = "vectorize_lambda"
  lambda_role_arn       = module.iam_vectorize_lambda.lambda_role_arn
  environment_variables = {}
  timeout               = 60
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  api_name          = "LambdaAPI"
  api_description   = "API Gateway for Lambda"
  resource_path     = "chat"
  lambda_arn        = module.lambda_chat.lambda_arn
  lambda_invoke_arn = module.lambda_chat.lambda_invoke_arn
  stage_name        = var.STAGE_NAME
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.BUCKET_NAME
  lambda_arn  = module.lambda_vectorize.lambda_arn
}

module "network" {
  source      = "./modules/network"
  vpc_cidr    = "10.20.0.0/16"
  subnet_cidr = "10.20.1.0/24"
}

module "rds" {
  source                 = "./modules/rds"
  aurora_master_username = var.AURORA_MASTER_USERNAME
  aurora_database_name   = var.AURORA_DATABASE_NAME
  aurora_master_password = var.AURORA_MASTER_PASSWORD
  security_group_id      = module.network.security_group_id
  subnet_ids             = module.network.subnet_ids
}
