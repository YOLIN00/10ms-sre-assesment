# Terraform Infrastructure as Code (IaC) Solution

This folder contains Terraform configurations for provisioning AWS infrastructure. The solution is modularized to manage different components of the infrastructure, such as VPC, EC2 instances, and SSH key pairs.

## Folder Structure

```
solution/
├── main.tf          # Root module to orchestrate infrastructure
├── variables.tf     # Input variables for the root module
├── outputs.tf       # Outputs for the root module
└── modules/         # Submodules for specific infrastructure components
    ├── vpc/         # VPC, Subnet, Route Table, Security Group
    ├── ec2/         # EC2 instance configuration
    └── ssh_keypair/ # SSH key pair generation and storage
```

## Modules

### VPC Module
- **Purpose**: Creates a VPC, Subnet, Internet Gateway, Route Table, and Security Group.
- **Key Resources**:
  - `aws_vpc`
  - `aws_subnet`
  - `aws_internet_gateway`
  - `aws_route_table`
  - `aws_security_group`
- **Notes**:
  - Security group allows SSH (port 22) and HTTPS (port 443) from all IPs. Update CIDR blocks for better security.

### EC2 Module
- **Purpose**: Provisions an EC2 instance.
- **Key Resources**:
  - `aws_instance`
- **Variables**:
  - `ami_id`: AMI ID for the instance (required).
  - `instance_type`: Instance type (default: `t2.micro`).
  - `subnet_id`: Subnet ID for the instance.
  - `sg_id`: Security group ID for the instance.
  - `key_pair_name`: Name of the SSH key pair.

### SSH Key Pair Module
- **Purpose**: Generates an SSH key pair and stores the private key in AWS Secrets Manager.
- **Key Resources**:
  - `tls_private_key`
  - `aws_key_pair`
  - `aws_secretsmanager_secret`

## Usage

### Prerequisites
- Terraform installed on your local machine.
- AWS credentials configured.

### Steps
1. **Initialize Terraform**:
   ```bash
   terraform init
   ```
2. **Plan the Infrastructure**:
   ```bash
   terraform plan 
   ```
3. **Apply the Configuration**:
   ```bash
   terraform apply 
   ```

### Variables
| Variable          | Type   | Default          | Description                     |
|-------------------|--------|------------------|---------------------------------|
| `region`          | string | `ap-south-1` | AWS region                     |
| `availability_zone` | string | `ap-south-1a` | AWS availability zone          |
| `instance_type`   | string | `t2.micro`       | EC2 instance type              |
| `ami_id`          | string | `ami-02b8269d5e85954ef`             | AMI ID for the EC2 instance    |

### Outputs
| Output Name       | Description                     |
|-------------------|---------------------------------|
| `ec2_public_ip`   | Public IP of the EC2 instance   |
| `ec2_public_dns`  | Public DNS of the EC2 instance  |
