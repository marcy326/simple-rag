resource "aws_api_gateway_deployment" "deployment" {
    rest_api_id = var.rest_api_id
    triggers = {
        redeployment = sha1(file("./modules/api_gateway_resource/main.tf"))
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_api_gateway_stage" "stage" {
    deployment_id = aws_api_gateway_deployment.deployment.id
    rest_api_id   = var.rest_api_id
    stage_name    = var.stage_name
}