# resource "aws_vpc" "main" {
#   cidr_block           = "10.1.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-vpc" })
#   )
# }

# # Create Internet Gateway
# resource "aws_internet_gateway" "main" {
#   vpc_id = aws_vpc.main.id

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-main" })
#   )
# }

# #####################################################
# # Public Subnets - Inbound/Outbound Internet Access #
# #####################################################
# resource "aws_subnet" "public_a" {
#   cidr_block              = "10.1.1.0/24"
#   map_public_ip_on_launch = true
#   vpc_id                  = aws_vpc.main.id
#   availability_zone       = "${data.aws_region.current.name}a"

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-public-a" })
#   )
# }

# resource "aws_route_table" "public_a" {
#   vpc_id = aws_vpc.main.id

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-public-a" })
#   )
# }

# resource "aws_route_table_association" "public_a" {
#   subnet_id      = aws_subnet.public_a.id
#   route_table_id = aws_route_table.public_a.id
# }

# resource "aws_route" "public_internet_access_a" {
#   route_table_id         = aws_route_table.public_a.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.main.id
# }

# resource "aws_eip" "public_a" {
#   vpc = true

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-public-a" })
#   )
# }

# resource "aws_nat_gateway" "public_a" {
#   allocation_id = aws_eip.public_a.id
#   subnet_id     = aws_subnet.public_a.id

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-public-a" })
#   )
# }

# resource "aws_subnet" "public_b" {
#   cidr_block              = "10.1.2.0/24"
#   map_public_ip_on_launch = true
#   vpc_id                  = aws_vpc.main.id
#   availability_zone       = "${data.aws_region.current.name}b"

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-public-b" })
#   )
# }

# resource "aws_route_table" "public_b" {
#   vpc_id = aws_vpc.main.id

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-public-b" })
#   )
# }

# resource "aws_route_table_association" "public_b" {
#   subnet_id      = aws_subnet.public_b.id
#   route_table_id = aws_route_table.public_b.id
# }

# resource "aws_route" "public_internet_access_b" {
#   route_table_id         = aws_route_table.public_b.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.main.id
# }

# resource "aws_eip" "public_b" {
#   vpc = true

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-public-b" })
#   )
# }

# resource "aws_nat_gateway" "public_b" {
#   allocation_id = aws_eip.public_b.id
#   subnet_id     = aws_subnet.public_b.id

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-public-b" })
#   )
# }


# ##################################################
# # Private Subnets - Outbound internt access only #
# ##################################################
# resource "aws_subnet" "private_a" {
#   cidr_block        = "10.1.10.0/24"
#   vpc_id            = aws_vpc.main.id
#   availability_zone = "${data.aws_region.current.name}a"

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-private-a" })
#   )
# }

# resource "aws_route_table" "private_a" {
#   vpc_id = aws_vpc.main.id

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-private-a" })
#   )
# }

# resource "aws_route_table_association" "private_a" {
#   subnet_id      = aws_subnet.private_a.id
#   route_table_id = aws_route_table.private_a.id
# }

# resource "aws_route" "private_a_internet_out" {
#   route_table_id         = aws_route_table.private_a.id
#   nat_gateway_id         = aws_nat_gateway.public_a.id
#   destination_cidr_block = "0.0.0.0/0"
# }

# resource "aws_subnet" "private_b" {
#   cidr_block        = "10.1.11.0/24"
#   vpc_id            = aws_vpc.main.id
#   availability_zone = "${data.aws_region.current.name}b"

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-private-b" })
#   )
# }

# resource "aws_route_table" "private_b" {
#   vpc_id = aws_vpc.main.id

#   tags = merge(
#     local.common_tags,
#     tomap({ Name = "${local.prefix}-private-b" })
#   )
# }

# resource "aws_route_table_association" "private_b" {
#   subnet_id      = aws_subnet.private_b.id
#   route_table_id = aws_route_table.private_b.id
# }

# resource "aws_route" "private_b_internet_out" {
#   route_table_id         = aws_route_table.private_b.id
#   nat_gateway_id         = aws_nat_gateway.public_b.id
#   destination_cidr_block = "0.0.0.0/0"
# }


// Create VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "${var.prefix}-${terraform.workspace}"
  cidr = "10.1.0.0/16"

  azs              = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  database_subnets = ["10.1.50.0/24", "10.1.51.0/24"]
  public_subnets   = ["10.1.101.0/24", "10.1.102.0/24"]

  // Options for the subnets
  enable_ipv6          = false
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  // VPC endpoint for S3
  enable_s3_endpoint = true

  // DB Subnet options
  create_database_subnet_route_table = true

  tags = merge(
    local.common_tags,
    tomap({ Name = "${local.prefix}-private-b" })
  )

}