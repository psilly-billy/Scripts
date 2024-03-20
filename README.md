
# Scripts
Different scripts to make your life easier

## Network Utilities and WordPress Installer

## Overview

This repository contains utilities for network management and automating the installation of WordPress on a Linux server. It includes two primary scripts:

### 1. `Subnet.py`

A Python script designed to calculate custom subnet information based on user input. It prompts the user for the number of needed subnets, the number of needed usable hosts, and the network address, then calculates and displays the subnet information, including the custom subnet mask and the number of usable addresses.

#### Key Features:

- Determines the IP class based on the network address provided.
- Calculates the number of bits needed for hosts and subnets, custom subnet mask, total number of subnets, total number of host addresses per subnet, and the number of usable addresses.
- Ensures the provided IP addresses are correct and not out of bounds, adhering to classful networking constraints.

### 2. `wop.sh`

A Bash script that automates the process of installing WordPress on a Linux server, specifically tailored for use with Apache and MySQL. The script guides the user through setting up the WordPress installation directory, database configuration, system updates, and Apache configuration.

#### Key Features:

- Prompts for WordPress installation details and database configuration.
- Updates the system and installs necessary components such as Apache (HTTPD) and PHP.
- Downloads and sets up WordPress in the specified directory.
- Configures Apache VirtualHost for the WordPress site.
- Checks if MySQL is installed and running, and exits if it's not found to ensure database connectivity.
- Sets appropriate file permissions for WordPress files.

## Prerequisites

- For `Subnet.py`:
  - Python 3.x installed on your machine.
  - Familiarity with IP addressing and subnetting concepts.

- For `wop.sh`:
  - A Linux server (Fedora or CentOS recommended).
  - Root or sudo access to execute system commands.
  - Apache (HTTPD) and MySQL installed and running.

## Usage

### `Subnet.py`

Run the script in your terminal with Python:
```bash
python Subnet.py
```
- Follow the prompts to input your subnetting requirements. Ensure that the network address you provide is valid and does not exceed the address space limits for the designated IP class.

### `wop.sh`
Make the script executable and run it:
```bash
chmod +x wop.sh
./wop.sh
```
- Follow the prompts to configure your WordPress installation. Ensure MySQL is installed and running before executing the script for database configuration.

## Contributing

Contributions are welcome! If you have improvements or fixes, please open a pull request or issue in the repository.
