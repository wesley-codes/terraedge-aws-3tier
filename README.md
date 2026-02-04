# Terraedge AWS 3-Tier (Terraform)

This project provisions a simple 3-tier AWS stack using Terraform: a VPC with public/private subnets, an internet-facing ALB, an Auto Scaling Group of EC2 instances, and a PostgreSQL RDS writer/reader pair in private subnets.

![Terraedge architecture](/Users/Meka/Documents/terraedge-aws-3tier/img.gif)

## Architecture (high level)
- VPC with public and private subnets across multiple AZs
- Internet Gateway + public route table for public subnets
- ALB in public subnets
- EC2 Auto Scaling Group in public subnets (behind the ALB)
- RDS (Postgres) writer + read replica in private subnets
- Security groups to allow ALB → app and app → RDS traffic
- Optional ACM/Route53/WAF module (disabled by default)

## Modules
- `modules/networking` — VPC, subnets, IGW, public route table
- `modules/security` — ALB/app/RDS security groups
- `modules/alb` — Application Load Balancer + target group + listener
- `modules/compute` — Launch template + Auto Scaling Group
- `modules/rds` — RDS subnet group + writer/reader instances
- `modules/acm_route53_waf` — ACM cert + Route53 records + WAF (optional)

## Prerequisites
- Terraform (provider `hashicorp/aws ~> 6.0`)
- AWS credentials configured (env vars, shared config, or SSO)
- AWS CLI (only required for the `wait-for-tg-healthy.sh` helper)

Region is set in `provider.tf` (default: `us-east-1`).

## Configuration
Edit `terraform.tfvars` with your desired values. Common inputs:
- `vpc_cidr_block`
- `az_count`
- `instance_type`
- `desired_capacity`, `min_size`, `max_size`
- `db_username`, `db_passwd`
- `domain_name` (only if enabling ACM/Route53)
- `enable_acm_route53_waf` (default: `false`)

Security note: do not commit real passwords to version control.

## Usage
Initialize and apply:
```bash
terraform init
./tf-apply.sh
```

The `tf-apply.sh` script:
- creates a plan
- applies the plan
- waits for the ALB target group to become healthy
- writes outputs to `outputs.json` and `outputs.txt`
- prints `asg_ec2_details`

To destroy:
```bash
terraform destroy
```

## Outputs
Notable outputs include:
- ALB DNS name and target group ARN
- Public/private subnet IDs and AZs
- RDS writer/reader details
- `asg_ec2_details` (instance ID, subnet, AZ, IPs, state)

## Optional ACM/Route53/WAF
The ACM/Route53/WAF module is disabled by default because it requires a real hosted zone. To enable it:
1) Purchase or create a domain and hosted zone in Route 53
2) Set `enable_acm_route53_waf = true` in `terraform.tfvars`
3) Set `domain_name` to your domain (e.g., `example.com`)

If you don’t have a domain, leave it disabled.

## Notes
- EC2 instances are launched in public subnets.
- RDS is private (`publicly_accessible = false`).
- There is no NAT gateway in this setup; private subnets have no outbound internet access.
