#!/bin/bash
# This User Data script installs and starts Apache web server
# The #!/bin/bash line is REQUIRED - I learned this the hard way!

sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
echo "AWS SAA-C03 Project" > /var/www/html/index.html

# Optional: Print status to logs for debugging
echo "User data completed at $(date)" >> /var/log/user-data.log