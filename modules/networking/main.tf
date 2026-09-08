locals {
  az_index = {
    for index, az in var.azs : az => index
  }

  public_subnets = {
    for az in var.azs : az => {
      cidr = var.public_subnet_cidrs[local.az_index[az]]
    }
  }

  private_subnets = {
    for az in var.azs : az => {
      cidr = var.private_subnet_cidrs[local.az_index[az]]
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = "olera-${var.environment}-vpc"
    Tier = "network"
  })
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "olera-${var.environment}-public-${each.key}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = each.value.cidr

  tags = merge(var.common_tags, {
    Name = "olera-${var.environment}-private-${each.key}"
    Tier = "private"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, {
    Name = "olera-${var.environment}-igw"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, {
    Name = "olera-${var.environment}-public-rt"
    Tier = "public"
  })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  for_each = toset(var.azs)

  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "olera-${var.environment}-nat-eip-${each.key}"
    Tier = "nat"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  for_each = toset(var.azs)

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(var.common_tags, {
    Name = "olera-${var.environment}-nat-${each.key}"
    Tier = "nat"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  for_each = toset(var.azs)

  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, {
    Name = "olera-${var.environment}-private-rt-${each.key}"
    Tier = "private"
  })
}

resource "aws_route" "private_nat" {
  for_each = toset(var.azs)

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
