#!/bin/bash

set -x
set -e

# List available Apache modules
ls /opt/bitnami/apache2/modules/

# Check currently loaded modules
httpd -M

# Remove existing LoadModule lines from httpd.conf
sed -i '/LoadModule /d' /opt/bitnami/apache2/conf/httpd.conf

# Ensure mod_unixd is loaded by appending it to the module list if not present
if ! grep -q "LoadModule unixd_module modules/mod_unixd.so" /opt/bitnami/scripts/modules_list; then
    echo "LoadModule unixd_module modules/mod_unixd.so" >> /opt/bitnami/scripts/modules_list
fi

# Add user and group settings to httpd.conf
sed -i '/^User /d' /opt/bitnami/apache2/conf/httpd.conf
sed -i '/^Group /d' /opt/bitnami/apache2/conf/httpd.conf
echo "User daemon" >> /opt/bitnami/apache2/conf/httpd.conf
echo "Group daemon" >> /opt/bitnami/apache2/conf/httpd.conf

# Append the custom modules list to the httpd.conf
cat /opt/bitnami/scripts/modules_list >> /opt/bitnami/apache2/conf/httpd.conf

# Reload Apache to apply changes
/opt/bitnami/scripts/apache/reload.sh

# Check the Apache status
/opt/bitnami/scripts/apache/status.sh

# Check the currently loaded modules again
httpd -M

# Ensure unixd_module is loaded
if ! httpd -M | grep -q "unixd_module"; then
    echo "Error: unixd_module is not loaded!"
    exit 1
fi
