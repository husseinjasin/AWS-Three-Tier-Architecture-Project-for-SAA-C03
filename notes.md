# Project Notes & Lessons Learned

## Timeline
- **Day 1:** Planned architecture and created VPC, subnets, IGW
- **Day 2:** Set up NAT Gateway, route tables, security groups
- **Day 3:** Created launch template, ALB, Auto Scaling Group
- **Day 4:** Launched RDS and S3 bucket
- **Day 5:** TESTING → Got 502 Bad Gateway error
- **Day 6:** Debugged and fixed the issue

## The 502 Error - Detailed Debugging

### Symptoms
- Website showed "502 Bad Gateway"
- ALB target group showed "unhealthy" for all instances
- No response from EC2 instances on port 80

### What I Checked (and was correct)
✅ Security groups allowed HTTP from ALB
✅ Route tables were properly configured
✅ Subnets had correct internet access
✅ ALB listener was on port 80
✅ Target group health check path was `/index.html`

### What Was Actually Wrong
❌ My User Data script was missing `#!/bin/bash`

### How I Found It
1. Looked at EC2 instance system logs in AWS console
2. Noticed Apache was not installed
3. Tried running the commands manually - they worked
4. Realized the script never executed
5. Googled "user data not running"
6. Found out I needed the shebang line

### The Fix
```bash
# Wrong (what I had)
sudo yum update -y
sudo yum install httpd -y

# Correct (what I needed)
#!/bin/bash
sudo yum update -y
sudo yum install httpd -y