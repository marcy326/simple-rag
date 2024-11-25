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

module "chat_lambda" {
  source                = "./modules/lambda"
  zip_file              = "./services/chat/lambda_function.zip"
  function_name         = "chat_lambda"
  lambda_role_arn       = module.iam_chat_lambda.lambda_role_arn
  environment_variables = { OPENAI_API_KEY = var.openai_api_key }
}

module "vectorize_lambda" {
  source                = "./modules/lambda"
  zip_file              = "./services/vectorize/lambda_function.zip"
  function_name         = "vectorize_lambda"
  lambda_role_arn       = module.iam_vectorize_lambda.lambda_role_arn
  environment_variables = {
    AURORA_PORT     = "5432"
    AURORA_USER     = var.db_user
    AURORA_PASSWORD = var.db_password
    AURORA_DB_NAME  = var.db_name
  }
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  api_name          = "LambdaAPI"
  api_description   = "API Gateway for Lambda"
}

module "api_gateway_resource_chat" {
  source                    = "./modules/api_gateway_resource"
  rest_api_id               = module.api_gateway.rest_api_id
  rest_api_root_resource_id = module.api_gateway.rest_api_root_resource_id
  rest_api_execution_arn    = module.api_gateway.rest_api_execution_arn
  resource_path             = "chat"
  lambda_arn                = module.chat_lambda.lambda_arn
  lambda_invoke_arn         = module.chat_lambda.lambda_invoke_arn
}

module "api_gateway_resource_vectorize" {
  source                    = "./modules/api_gateway_resource"
  rest_api_id               = module.api_gateway.rest_api_id
  rest_api_root_resource_id = module.api_gateway.rest_api_root_resource_id
  rest_api_execution_arn    = module.api_gateway.rest_api_execution_arn
  resource_path             = "vectorize"
  lambda_arn                = module.vectorize_lambda.lambda_arn
  lambda_invoke_arn         = module.vectorize_lambda.lambda_invoke_arn
}

module "api_gateway_deployment" {
  source      = "./modules/api_gateway_deployment"
  rest_api_id = module.api_gateway.rest_api_id
  stage_name  = var.stage_name
  depends_on = [
    module.api_gateway_resource_chat.created,
    module.api_gateway_resource_vectorize.created
  ]
}