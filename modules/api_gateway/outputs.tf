output "rest_api_id" {
    value = aws_api_gateway_rest_api.rest_api.id
}

output "rest_api_root_resource_id" {
    value = aws_api_gateway_rest_api.rest_api.root_resource_id
}

output "rest_api_execution_arn" {
    value = aws_api_gateway_rest_api.rest_api.execution_arn
}