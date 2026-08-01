# AWS Three-Tier Architecture Project for SAA-C03

## Project Overview
I built a highly available, secure web application on AWS to practice for the SAA-C03 exam. The architecture includes a custom VPC, public/private subnets across two Availability Zones, an Application Load Balancer, Auto Scaling Group, RDS MySQL database, and S3 storage.

## Architecture
Client (Internet)
│
▼
┌──────────────┐
│ ALB │ (Public Subnets A & B)
└──────────────┘
│
▼
┌──────────────┐
│ Auto Scaling│ (Private Subnets A & B)
│ Group (EC2) │
└──────────────┘
│
▼
┌──────────────┐ ┌──────────────┐
│ RDS MySQL │ │ S3 Bucket │
│ (Multi-AZ) │ │ (Images/Files)│
└──────────────┘ └──────────────┘

text

## Services Used
| Service | Purpose |
|---------|---------|
| VPC | Isolated network with CIDR 10.0.0.0/16 |
| Internet Gateway | Public internet access |
| NAT Gateway | Outbound internet for private subnets |
| Application Load Balancer | Distributes traffic across EC2 instances |
| Auto Scaling Group | Maintains 2-5 EC2 instances based on CPU |
| EC2 (t2.micro) | Web servers running Apache |
| RDS MySQL (Multi-AZ) | Database with automatic failover |
| S3 | Static file storage with versioning & encryption |

## What I Built

### Networking
- **VPC:** Production-VPC (10.0.0.0/16) in eu-west-1
- **Subnets (2 AZs):**
  - Public A: 10.0.1.0/24 | Public B: 10.0.2.0/24
  - Private A: 10.0.10.0/24 | Private B: 10.0.20.0/24
- **Route Tables:** Public → IGW | Private → NAT Gateway
- **NAT Gateway:** Placed in Public Subnet A with Elastic IP

### Security Groups
| Group | Inbound Rules |
|-------|---------------|
| ALB | HTTP 80 (0.0.0.0/0), HTTPS 443 (0.0.0.0/0) |
| EC2 | HTTP 80 (ALB Security Group only) |
| RDS | MySQL 3306 (EC2 Security Group only) |

### Compute & Scaling
- **Launch Template:** Amazon Linux 2023, t2.micro
- **Auto Scaling:** Min 2, Desired 2, Max 5
- **Scaling Policy:** Add instance when CPU > 70%

### Database
- **Engine:** MySQL (Multi-AZ for high availability)
- **Placement:** Private subnets only
- **Security:** Only EC2 security group can connect

### Storage
- **S3 Bucket:** Versioning + Encryption enabled
- **Use cases:** Images, backups, static files

## The Problem I Fixed (502 Bad Gateway)

### Issue
After deploying everything, I got a **502 Bad Gateway** error. The ALB target group showed all EC2 instances as unhealthy.

### Root Cause
I forgot to add `#!/bin/bash` at the top of my User Data script. Without this, Cloud-init only executed the first command (`sudo yum update -y`) and ignored the rest. Apache was never installed.

### Solution
1. Terminated the old EC2 instances
2. Updated the launch template with correct User Data (see `user-data.sh`)
3. Let Auto Scaling Group launch new instances
4. Health checks passed within 2-3 minutes
5. Website displayed "AWS SAA-C03 Project"

### Lesson Learned
**Always start User Data scripts with `#!/bin/bash`** — otherwise only the first line runs.

## How to Recreate This Project
1. Create VPC with CIDR 10.0.0.0/16
2. Attach Internet Gateway
3. Create subnets as shown above
4. Create NAT Gateway in Public Subnet A
5. Configure route tables
6. Create security groups
7. Create launch template with `user-data.sh`
8. Create target group and ALB
9. Create Auto Scaling Group
10. Launch RDS MySQL (Multi-AZ)
11. Create S3 bucket with versioning

## What I Learned
- VPC networking (public/private subnets, route tables, NAT)
- Load balancer health checks and target groups
- Auto Scaling policies
- Security group chaining
- User data debugging (shebang line!)
- Multi-AZ database configuration

## Next Steps
- Add HTTPS with Certificate Manager
- Connect RDS to EC2 with real database queries
- Add CloudFront CDN for static assets
- Write Infrastructure as Code using Terraform
