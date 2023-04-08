locals {
  target_vpc_id             = "vpc-08deb085d6817c7f3"                                  #sbcntrVpc
  target_subnet_ids         = ["subnet-046e0fbfd80d96cec", "subnet-07ba6c36eaea0de80"] #egress-Subnet
  target_security_group_ids = ["sg-0d30b2d1335b7d0af"]                                 #egress-SecurityGroup
  target_route_table_ids    = ["rtb-0f180a2b17498beb6"]                                #App RouteTable
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = local.target_vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.target_subnet_ids
  security_group_ids  = local.target_security_group_ids
  tags = {
    Name = "sbcntr-vpce-ssm"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = local.target_vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.target_subnet_ids
  security_group_ids  = local.target_security_group_ids
  tags = {
    Name = "sbcntr-vpce-ssm-messages"
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = local.target_vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.target_subnet_ids
  security_group_ids  = local.target_security_group_ids
  tags = {
    Name = "sbcntr-vpce-secrets"
  }
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = local.target_vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.target_subnet_ids
  security_group_ids  = local.target_security_group_ids
  tags = {
    Name = "sbcntr-vpce-logs"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = local.target_vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.target_subnet_ids
  security_group_ids  = local.target_security_group_ids
  tags = {
    Name = "sbcntr-vpce-ecr-dkr"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = local.target_vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.target_subnet_ids
  security_group_ids  = local.target_security_group_ids
  tags = {
    Name = "sbcntr-vpce-ecr-api"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id              = local.target_vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type   = "Gateway"
  private_dns_enabled = false
  route_table_ids     = local.target_route_table_ids
  tags = {
    Name = "sbcntr-vpce-s3"
  }
}
