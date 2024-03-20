#!/bin/bash

echo "Starting WordPress installation process..."

# Prompt for WordPress installation folder, with 'html' as default
read -p "Enter the folder name for WordPress installation (default 'html'): " wp_folder
wp_install_dir=${wp_folder:-html}  # Default to 'html' if input is empty
full_wp_install_dir="/var/www/html/$wp_install_dir"

# Create directory
echo "Creating wordpress directory......."
sudo mkdir -p "$full_wp_install_dir"


# Prompt for database details
read -p "Enter the database host- press Enter to use default localhost: " db_host
db_host=${db_host:-localhost}  # Default to localhost if input is empty
read -p "Enter the database name: " db_name
read -p "Enter the database user: " db_user
read -sp "Enter the database password: " db_pass
echo

# Update system
echo "Updating system..."
#sudo dnf update -y &>/dev/null
sudo dnf install nano -y &>/dev/null
sudo dnf install wget -y &>/dev/null

# Install HTTPD and PHP
echo "Installing HTTPD (Apache) and PHP..."
sudo yum install httpd php php-mysqlnd -y &>/dev/null

# Start and enable Apache
echo "Starting and enabling HTTPD (Apache)..."
sudo systemctl start httpd &>/dev/null
sudo systemctl enable httpd &>/dev/null


# Configure Httpd Document root
echo "Configuring Httpd..."
sudo bash -c "echo '<VirtualHost *:80>
    DocumentRoot \"$full_wp_install_dir\"
    <Directory \"$full_wp_install_dir\">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>' > /etc/httpd/conf.d/wordpress.conf"
sudo systemctl restart httpd

# Check if MySQL is installed and running
echo "Checking for MySQL..."
if ! systemctl is-active --quiet mysqld; then
    echo "MySQL is not running. Please install and start MySQL before continuing."
    exit 1
fi

# Download and extract WordPress
echo "Downloading and setting up WordPress..."
wget -q -O /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz
tar -xf /tmp/latest.tar.gz -C /tmp &>/dev/null
sudo mv /tmp/wordpress/* "$full_wp_install_dir"

# Configure WordPress
echo "Configuring WordPress..."
sudo cp "$full_wp_install_dir/wp-config-sample.php" "$full_wp_install_dir/wp-config.php"
sudo sed -i "s/database_name_here/$db_name/g" "$full_wp_install_dir/wp-config.php"
sudo sed -i "s/username_here/$db_user/g" "$full_wp_install_dir/wp-config.php"
sudo sed -i "s/password_here/$db_pass/g" "$full_wp_install_dir/wp-config.php"
sudo sed -i "s/localhost/$db_host/g" "$full_wp_install_dir/wp-config.php"

# Set permissions
echo "Setting file permissions..."
sudo chown -R apache:apache "$full_wp_install_dir"
sudo find "$full_wp_install_dir" -type d -exec chmod 755 {} \; &>/dev/null
sudo find "$full_wp_install_dir" -type f -exec chmod 644 {} \; &>/dev/null


echo "WordPress installation completed!"
