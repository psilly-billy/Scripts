# Updated function to calculate custom subnet information based on user input
import numpy as np
import ipaddress

def calculate_custom_subnet_info_from_input():
    # User inputs for the network requirements
    number_of_subnets_needed = int(input("Number of needed subnets: "))
    number_of_usable_hosts_needed = int(input("Number of needed usable hosts: "))
    network_address = input("Network Address: ")

    # IP Class and default subnet masks
    ip_classes = {
        'A': '255.0.0.0',
        'B': '255.255.0.0',
        'C': '255.255.255.0'
    }
    
    # Determine address class based on the network address
    first_octet = int(network_address.split('.')[0])
    if first_octet >= 1 and first_octet <= 126:
        ip_class = 'A'
    elif first_octet >= 128 and first_octet <= 191:
        ip_class = 'B'
    elif first_octet >= 192 and first_octet <= 223:
        ip_class = 'C'
    else:
        raise ValueError("Invalid network address for classful subnetting.")
    
    # Calculate the number of bits needed for hosts and subnets
    host_bits = int(np.ceil(np.log2(number_of_usable_hosts_needed + 2)))  # +2 for network and broadcast addresses
    subnet_bits = int(np.ceil(np.log2(number_of_subnets_needed)))
    total_bits = 32  # For IPv4

    # Calculate the subnet mask in bits
    mask_bits = total_bits - host_bits
    # Convert the mask into decimal format
    custom_subnet_mask = str(ipaddress.IPv4Address((1 << total_bits) - (1 << host_bits)))
    
    # Calculate total number of subnets (power of two)
    total_subnets = 2 ** subnet_bits
    
    # Calculate total number of host addresses per subnet
    total_host_addresses = 2 ** host_bits
    
    # Number of usable addresses is total minus 2 (network and broadcast)
    usable_addresses = total_host_addresses - 2
    
    # Number of bits borrowed is the difference between default and custom mask bits
    default_mask_bits = sum([bin(int(x)).count('1') for x in ip_classes[ip_class].split('.')])
    bits_borrowed = mask_bits - default_mask_bits
    
    # Print the subnet information
    subnet_info = {
        'Address class': ip_class,
        'Default subnet mask': ip_classes[ip_class],
        'Custom subnet mask': custom_subnet_mask,
        'Total number of subnets': total_subnets,
        'Total number of host addresses': total_host_addresses,
        'Number of usable addresses': usable_addresses,
        'Number of bits borrowed': bits_borrowed
    }
    
    for key, value in subnet_info.items():
        print(f"{key}: {value}")

# Call the function to get user input and calculate subnet information
calculate_custom_subnet_info_from_input()
